require_relative 'exceptions'

module MediaWiki
  module Auth
    # Checks the login result for errors. Returns true if it is successful,
    #   else false with an error raised.
    # @param result [String] The parsed version of the result.
    # @param secondtry [Boolean] Whether this login is the first or second try.
    #   False for first, true for second.
    # @return [Boolean] true if successful. Does not return anything if not.
    def check_login(result, secondtry)
      case result
      when 'Success'
        @logged_in = true
        return true
      when 'NeedToken'
        fail MediaWiki::Butt::NeedTokenMoreThanOnceError if secondtry == true
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

    # Checks the account creation result's error and raises the corresponding
    #   exception.
    # @param error [String] The parsed error code string
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

    # Logs the user into the wiki. This is generally required for editing and
    #   getting restricted data. Will return the result of #check_login
    # @param username [String] The username
    # @param password [String] The password
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
        @cookie = "#{result['login']['cookieprefix']}" \
                  "Session=#{result['login']['sessionid']}"
        result = post(token_params, true, 'Set-Cookie' => @cookie)
        @name = username if check_login(result['login']['result'], true) == true
      end
    end

    # Logs the current user out.
    # @return [Boolean] True if it was able to log anyone out, false if not
    #   (basically, if someone was logged in, it returns true).
    def logout
      if @logged_in
        params = {
          action: 'logout'
        }

        post(params)
        @logged_in = false
        @tokens.clear
        return true
      else
        return false
      end
    end

    # Creates an account using the standard procedure.
    # @param username [String] The desired username.
    # @param password [String] The desired password.
    # @param language [String] The language code to be set as default for the
    #   account. Defaults to 'en', or English. Use the language code, not
    #   the name.
    # @param reason [String] The reason for creating the account, as shown in
    #   the account creation log. Optional.
    # @return [Boolean] True if successful, false if not.
    def create_account(username, password, language = 'en', *reason)
      params = {
        name: username,
        password: password,
        reason: reason,
        language: language,
        token: ''
      }

      result = post(params)
      unless result['error'].nil?
        check_create(result['error']['code'])
        return false
      end

      if result['createaccount']['result'] == 'Success'
        @tokens.clear
        return true
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
    # @param username [String] The desired username
    # @param email [String] The desired email address
    # @param language [String] The language code to be set as default for the
    #   account. Defaults to 'en', or English. Use the language code, not
    #   the name.
    # @param reason [String] The reason for creating the account, as shown in
    #   the account creation log. Optional.
    # @return [Boolean] True if successful, false if not.
    def create_account_email(username, email, language = 'en', *reason)
      params = {
        name: username,
        email: email,
        mailpassword: 'value',
        reason: reason,
        language: language,
        token: ''
      }

      result = post(params)
      unless result['error'].nil?
        check_create(result['error']['code'])
        return false
      end

      if result['createaccount']['result'] == 'Success'
        @tokens.clear
        return true
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
