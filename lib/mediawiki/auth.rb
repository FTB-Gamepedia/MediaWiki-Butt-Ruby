require_relative 'exceptions'

module MediaWiki
  module Auth
    # Checks the login result for errors and raises errors accordingly.
    # @param result [String] The parsed version of the result.
    # @param secondtry [Boolean] Whether this login is the first or second try. False for first, true for second.
    # @raise [NeedTokenMoreThanOnceError] When secondtry is true and the wiki still returns 'NeedToken'
    # @raise [NoNameError] When the username is nil or undefined.
    # @raise [IllegalUsernameError] When the username is illegal.
    # @raise [UsernameNotExistsError] When the username does not exist.
    # @raise [EmptyPassError] When the password is nil or undefined.
    # @raise [WrongPassError] When the password is incorrect.
    # @raise [WrongPluginPassError] When an authentication plugin, not MediaWiki, claims that the password is incorrect.
    # @raise [CreateBlockedError] When the wiki tries to automatically create an account, but the user's IP address
    # is already blocked.
    # @raise [ThrottledError] When the user has logged in, or tried to, too much in a particular amount of time.
    # @raise [BlockedError] When the user is blocked from the wiki.
    # @since 0.1.0
    # @return [Boolean] true if successful. Does not return anything otherwise.
    def check_login(result, secondtry)
      case result
      when 'Success'
        @logged_in = true
        return true
      when 'NeedToken'
        fail MediaWiki::Butt::NeedTokenMoreThanOnceError if secondtry
      when 'NoName'
        fail MediaWiki::Butt::NoNameError
      when 'Illegal'
        fail MediaWiki::Butt::IllegalUsernameError
      when 'NotExists'
        fail MediaWiki::Butt::UsernameNotExistsError
      when 'EmptyPass'
        fail MediaWiki::Butt::EmptyPassError
      when 'WrongPass'
        fail MediaWiki::Butt::WrongPassError
      when 'WrongPluginPass'
        fail MediaWiki::Butt::WrongPluginPassError
      when 'CreateBlocked'
        fail MediaWiki::Butt::CreateBlockedError
      when 'Throttled'
        fail MediaWiki::Butt::ThrottledError
      when 'Blocked'
        fail MediaWiki::Butt::BlockedError
      end
    end

    # Checks the account creation result's error and raises the corresponding exception.
    # @param error [String] The parsed error code string
    # @raise [NoNameError] When the username was either not provided or is invalid.
    # @raise [UserExistsError] When the username is already in use.
    # @raise [UserPassMatchError] When the username and password are identical.
    # @raise [PasswordLoginForbiddenError] When the use of the username and password has been forbidden.
    # @raise [NoEmailTitleError] When there is no provided email address.
    # @raise [InvalidEmailAddressError] When the email address has an invalid format.
    # @raise [PasswordTooShortError] When the password is shorter than the $wgMinimumPasswordLength option.
    # @raise [NoEmailError] When there is no email address set for the user.
    # @raise [ThrottledError] When the user has created too many accounts in one day.
    # @raise [AbortedError] When an extension has aborted this action.
    # @raise [BlockedError] When the IP or logged in user is blocked.
    # @raise [PermDeniedError] When the user does not have the right to create accounts.
    # @raise [HookAbortedError] Same as AbortedError.
    # @since 0.1.1
    # @return [void]
    def check_create(error)
      case error
      when 'noname'
        fail MediaWiki::Butt::NoNameError
      when 'userexists'
        fail MediaWiki::Butt::UserExistsError
      when 'password-name-match'
        fail MediaWiki::Butt::UserPassMatchError
      when 'password-login-forbidden'
        fail MediaWiki::Butt::PasswordLoginForbiddenError
      when 'noemailtitle'
        fail MediaWiki::Butt::NoEmailTitleError
      when 'invalidemailaddress'
        fail MediaWiki::Butt::InvalidEmailAddressError
      when 'passwordtooshort'
        fail MediaWiki::Butt::PasswordTooShortError
      when 'noemail'
        fail MediaWiki::Butt::NoEmailError
      when 'acct_creation_throttle_hit'
        fail MediaWiki::Butt::ThrottledError
      when 'aborted'
        fail MediaWiki::Butt::AbortedError
      when 'blocked'
        fail MediaWiki::Butt::BlockedError
      when 'permdenied-createaccount'
        fail MediaWiki::Butt::PermDeniedError
      when 'createaccount-hook-aborted'
        fail MediaWiki::Butt::HookAbortedError
      end
    end

    # Logs the user into the wiki. This is generally required for editing and getting restricted data.
    # @param username [String] The username
    # @param password [String] The password
    # @see #check_login
    # @see https://www.mediawiki.org/wiki/API:Login MediaWiki Login API Docs
    # @since 0.1.0
    # @return [Boolean] True if the login was successful, false if not.
    def login(username, password)
      params = {
        action: 'login',
        lgname: username,
        lgpassword: password
      }

      result = post(params)
      if check_login(result['login']['result'], false)
        @logged_in = true
        @tokens.clear
        true
      elsif result['login']['result'] == 'NeedToken' &&
            !result['login']['token'].nil?
        token = result['login']['token']
        token_params = {
          action: 'login',
          lgname: username,
          lgpassword: password,
          lgtoken: token
        }

        # Consider refactor the @cookie initialization.
        @cookie = "#{result['login']['cookieprefix']}Session=#{result['login']['sessionid']}"
        result = post(token_params, true, 'Set-Cookie' => @cookie)
        check = check_login(result['login']['result'], true)
        @name = username if check
        return check
      end

      false
    end

    # Logs the current user out.
    # @see https://www.mediawiki.org/wiki/API:Logout MediaWiki Logout API Docs
    # @since 0.1.0
    # @return [Boolean] True if it was able to log anyone out, false if not.
    def logout
      if @logged_in
        params = {
          action: 'logout'
        }

        post(params)
        @logged_in = false
        @tokens.clear

        true
      else
        false
      end
    end

    # Creates an account using the standard procedure.
    # @param username [String] The desired username.
    # @param password [String] The desired password.
    # @param language [String] The language code to be set as default for the account. Defaults to 'en', or English.
    # Use the language code, not the name.
    # @param reason [String] The reason for creating the account, as shown in the account creation log. Optional.
    # @see #check_create
    # @see https://www.mediawiki.org/wiki/API:Account_creation MediaWiki Account Creation Docs
    # @since 0.1.0
    # @return [Boolean] True if successful, false if not.
    def create_account(username, password, language = 'en', reason = nil)
      params = {
        name: username,
        password: password,
        language: language,
        token: ''
      }
      params[:reason] = reason unless reason.nil?

      result = post(params)
      unless result['error'].nil?
        check_create(result['error']['code'])
        return false
      end

      if result['createaccount']['result'] == 'Success'
        @tokens.clear

        true
      elsif result['createaccount']['result'] == 'NeedToken'
        params = {
          name: username,
          password: password,
          reason: reason,
          language: language,
          token: result['createaccount']['token']
        }

        result = post(params, true, true)
        if !result['error'].nil?
          check_create(result['error']['code'])
          return false
        elsif result['createaccount']['result'] == 'Success'
          return true
        else
          return false
        end
      end
    end

    # Creates an account using the random password sent by email procedure.
    # @param email [String] The desired email address
    # @param (see #create_account)
    # @see #check_create
    # @see https://www.mediawiki.org/wiki/API:Account_creation MediaWiki Account Creation Docs
    # @since 0.1.0
    # @return [Boolean] True if successful, false if not.
    def create_account_email(username, email, language = 'en', reason = nil)
      params = {
        name: username,
        email: email,
        mailpassword: 'value',
        language: language,
        token: ''
      }
      params[:reason] = reason unless reason.nil?

      result = post(params)
      unless result['error'].nil?
        check_create(result['error']['code'])
        return false
      end

      if result['createaccount']['result'] == 'Success'
        @tokens.clear

        true
      elsif result['createaccount']['result'] == 'NeedToken'
        params = {
          name: username,
          email: email,
          mailpassword: 'value',
          reason: reason,
          language: language,
          token: result['createaccount']['token']
        }

        result = post(params, true, true)
        if !result['error'].nil?
          check_create(result['error']['code'])
          return false
        elsif result['createaccount']['result'] == 'Success'
          return true
        else
          return false
        end
      end
    end
  end
end
