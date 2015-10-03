require_relative 'exceptions'

module MediaWiki
  module Auth

    # Checks the login result for errors. Returns true if it is successful, else false with an error raised.
    # @param result [String] The parsed version of the result.
    # @param secondtry [Boolean] Whether this login is the first or second try. False for first, true for second.
    # @return [Boolean] true if successful, else false.
    def check_login(result, secondtry)
      if result == "Success"
        @logged_in = true
      elsif result == "NeedToken" && secondtry == true
        raise MediaWiki::Butt::NeedTokenMoreThanOnceError
        false
      elsif result == "NoName"
        raise MediaWiki::Butt::NoNameError
        false
      elsif result == "Illegal"
        raise MediaWiki::Butt::IllegalUsernameError
        false
      elsif result == "NotExists"
        raise MediaWiki::Butt::UsernameNotExistsError
        false
      elsif result == "EmptyPass"
        raise MediaWiki::Butt::EmptyPassError
        false
      elsif result == "WrongPass"
        raise MediaWiki::Butt::WrongPassError
        false
      elsif result == "WrongPluginPass"
        raise MediaWiki::Butt::WrongPluginPassError
        false
      elsif result == "CreateBlocked"
        raise MediaWiki::Butt::CreateBlockedError
        alse
      elsif result == "Throttled"
        raise MediaWiki::Butt::ThrottledError
        false
      elsif result == "Blocked"
        raise MediaWiki::Butt::BlockedError
        false
      end
    end

    # Checks the account creation result's error and raises the corresponding error.
    # @param error [String] The parsed error "code" string
    # @return [Boolean] Always false
    def check_create(error)
      if error == "noname"
        raise MediaWiki::Butt::NoNameError
        false
      elsif error == "userexists"
        raise MediaWiki::Butt::UserExistsError
        false
      elsif error == "password-name-match"
        raise MediaWiki::Butt::UserPassMatchError
        false
      elsif error == "password-login-forbidden"
        raise MediaWiki::Butt::PasswordLoginForbiddenError
        false
      elsif error == "noemailtitle"
        raise MediaWiki::Butt::NoEmailTitleError
        false
      elsif error == "invalidemailaddress"
        raise MediaWiki::Butt::InvalidEmailAddressError
        false
      elsif error == "passwordtooshort"
        raise MediaWiki::Butt::PasswordTooShortError
        false
      elsif error == "noemail"
        raise MediaWiki::Butt::NoEmailError
        false
      elsif error == "acct_creation_throttle_hit"
        raise MediaWiki::Butt::ThrottledError
        false
      elsif error == "aborted"
        raise MediaWiki::Butt::AbortedError
        false
      elsif error == "blocked"
        raise MediaWiki::Butt::BlockedError
        false
      elsif error == "permdenied-createaccount"
        raise MediaWiki::Butt::PermDeniedError
        false
      elsif error == "createaccount-hook-aborted"
        raise MediaWiki::Butt::HookAbortedError
        false
      end
    end

    # Logs the user into the wiki. This is generally required for editing and getting restricted data. Will return the result of #check_login
    # @param username [String] The username
    # @param password [String] The password
    # @return [Boolean] True if the login was successful, false if not.
    def login(username, password)
      params = {
        action: 'login',
        lgname: username,
        lgpassword: password,
        format: 'json'
      }

      result = post(params)
      if check_login(result["login"]["result"], false)
        @logged_in = true
        @tokens.clear
        true
      elsif result["login"]["result"] == "NeedToken" && result["login"]["token"] != nil
        token = result["login"]["token"]
        token_params = {
          action: 'login',
          lgname: username,
          lgpassword: password,
          format: 'json',
          lgtoken: token
        }

        #Consider refactor the @cookie initialization.
        @cookie = "#{result["login"]["cookieprefix"]}Session=#{result["login"]["sessionid"]}"
        result = post(token_params, true, { 'Set-Cookie' => @cookie })
        check_login(result["login"]["result"], true)
      end
    end

    # Logs the current user out.
    # @return [Boolean] True if it was able to log anyone out, false if not (basically, if someone was logged in, it returns true).
    def logout
      if @logged_in
        params = {
          action: 'logout',
          format: 'json'
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
    # @param language [String] The language code to be set as default for the account. Defaults to 'en', or English. Use the language code, not the name.
    # @param reason [String] The reason for creating the account, as shown in the account creation log. Optional.
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
      if result["error"] != nil
        check_create(result["error"]["code"])
        return false
      end

      if result["createaccount"]["result"] == "Success"
        @tokens.clear
        return true
      elsif result["createaccount"]["result"] == "NeedToken"
        params = {
          name: username,
          password: password,
          reason: reason,
          language: language,
          token: result["createaccount"]["token"]
        }

        result = post(params, true, true)
        if result["error"] != nil
          check_create(result["error"]["code"])
          return false
        elsif result["createaccount"]["result"] == "Success"
          return true
        else
          return false
        end
      end
    end

    # Creates an account using the random password sent by email procedure.
    # @param username [String] The desired username
    # @param email [String] The desired email address
    # @param language [String] The language code to be set as default for the account. Defaults to 'en', or English. Use the language code, not the name.
    # @param reason [String] The reason for creating the account, as shown in the account creation log. Optional.
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
      result = post(params)
      if result["error"] != nil
        check_create(result["error"]["code"])
        return false
      end

      if result["createaccount"]["result"] == "Success"
        @tokens.clear
        return true
      elsif result["createaccount"]["result"] == "NeedToken"
        params = {
          name: username,
          email: email,
          mailpassword: 'value',
          reason: reason,
          language: language,
          token: result["createaccount"]["token"]
        }

        result = post(params, true, true)
        if result["error"] != nil
          check_create(result["error"]["code"])
          return false
        elsif result["createaccount"]["result"] == "Success"
          return true
        else
          return false
        end
      end
    end
  end
end
