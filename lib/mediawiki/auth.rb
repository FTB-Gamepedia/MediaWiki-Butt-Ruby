require_relative 'exceptions'

module MediaWiki
  module Auth

    # Checks the login result for errors. Return true if success, else false, and will raise an error if it is not successful.
    #
    # ==== Attributes
    #
    # * +result+ - The parsed version of the result parameter of the login action.
    # * +secondtry+ - Whether this login is the first or second try, false for first, true for second.
    #
    # ==== Examples
    #
    # This method should not be used by normal users.
    def check_login(result, secondtry)
      if result == "Success"
        return true
      elsif result == "NeedToken" && secondtry == true
        raise MediaWiki::Butt::NeedTokenMoreThanOnceError
        return false
      elsif result == "NoName"
        raise MediaWiki::Butt::NoNameError
        return false
      elsif result == "Illegal"
        raise MediaWiki::Butt::IllegalUsernameError
        return false
      elsif result == "NotExists"
        raise MediaWiki::Butt::UsernameNotExistsError
        return false
      elsif result == "EmptyPass"
        raise MediaWiki::Butt::EmptyPassError
        return false
      elsif result == "WrongPass"
        raise MediaWiki::Butt::WrongPassError
        return false
      elsif result == "WrongPluginPass"
        raise MediaWiki::Butt::WrongPluginPassError
        return false
      elsif result == "CreateBlocked"
        raise MediaWiki::Butt::CreateBlockedError
        return false
      elsif result == "Throttled"
        raise MediaWiki::Butt::ThrottledError
        return false
      elsif result == "Blocked"
        raise MediaWiki::Butt::BlockedError
        return false
      end
    end
    # Logs the user in to the wiki. This is generally required for editing, or getting restricted data.
    # Will return the result of check_login.
    #
    # ==== Attributes
    #
    # * +username+ - The desired login handle
    # * +password+ - The password of that user
    #
    # ==== Examples
    #
    # => butt.login("MyUsername", "My5up3r53cur3P@55w0rd")
    def login(username, password)
      params = {
        action: 'login',
        lgname: username,
        lgpassword: password,
        format: 'json'
      }

      result = post(params, true, false)
      if check_login(result["login"]["result"], false) == true
        @logged_in = true
        @tokens.clear
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
        result = post(token_params, true, true)
        return check_login(result["login"]["result"], true)
      end
    end

    # Logs the current user out
    #
    # ==== Examples
    #
    # => butt.login("MyUsername", "My5up3r53cur3P@55w0rd")
    # => # do stuff
    # => butt.logout
    def logout
      if @logged_in == true
        params = {
          action: 'logout'
        }

        post(params)
        @logged_in = false
        @tokens.clear
      end
    end

    # Creates an account using the standard procedure.
    #
    # ==== Attributes
    #
    # *+username+ - The desired username
    # *+password+ - The desired password.
    # *+language+ - The language code to set as default for the account being created. Defaults to 'en' or English. Use the language code, not the name.
    # *+reason+ - The reason for creating the account, shown in the account creation log. Optional.
    #
    # ==== Examples
    #
    # => butt.create_account("MyUser", "password", "es", "MyEmailAddress@MailMain.com", "Quiero un nuevo acuenta sin embargo correocontraseña")
    def create_account(username, password, language = 'en', *reason)
      params = {
        name: username,
        password: password,
        reason: reason,
        language: language,
        token: ''
      }

      result = post(params)

      if result["createaccount"]["result"] == "Success"
        @tokens.clear
      elsif result["createaccount"]["result"] == "NeedToken"
        params = {
          name: username,
          password: password,
          reason: reason,
          language: language,
          token: result["createaccount"]["token"]
        }
      end
    end

    # Creates an account using the random-password-sent-by-email procedure.
    #
    # ==== Attributes
    #
    # *+username+ - The desired username
    # *+email+ - The desired email address.
    # *+reason+ - The reason for creating the account, shown in the account creation log. Optional.
    # *+language+ - The language code to set as default for the account being created. Defaults to 'en' or English. Use the language code, not the name.
    #
    # ==== Examples
    #
    # => butt.create_account_email("MyUser", "MyEmailAddress@Whatever.com", "es", "Quiero una nueva acuenta porque quiero a comer caca")
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

      if result["createaccount"]["result"] == "Success"
        @tokens.clear
      elsif result["createaccount"]["result"] == "NeedToken"
        params = {
          name: username,
          email: email,
          mailpassword: 'value',
          reason: reason,
          language: language,
          token: result["createaccount"]["token"]
        }
      end
    end
  end
end
