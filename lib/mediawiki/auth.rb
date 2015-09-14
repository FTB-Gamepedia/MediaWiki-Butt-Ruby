module MediaWiki
  module Auth
    # Logs the user in to the wiki. This is generally required for editing, or getting restricted data.
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

      result = post(params)
      if result["login"]["result"] == "Success"
        @logged_in = true
        @tokens.clear
      elsif result["login"]["result"] == "NeedToken" && result["login"]["token"] != nil
        token_params = {
          action: 'login',
          lgname: username,
          lgpassword: password,
          lgtoken: result["login"]["token"],
          format: 'json'
        }

        # There is no need to autoparse this, because we don't do anything with it.
        post(token_params, false)
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
