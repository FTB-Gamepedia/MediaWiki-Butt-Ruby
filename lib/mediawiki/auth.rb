require_relative 'exceptions'

module MediaWiki
  module Auth
    # Logs the user into the wiki. This is generally required for editing and getting restricted data.
    # @param username [String] The username
    # @param password [String] The password
    # @see https://www.mediawiki.org/wiki/API:Login MediaWiki Login API Docs
    # @since 0.1.0
    # @raise [AuthenticationError]
    # @return [Boolean] True if the login was successful.
    def login(username, password)
      # Save the assertion value while trying to log in, because otherwise the assertion will prevent us from logging in
      assertion_value = @assertion.clone
      @assertion = nil

      params = {
        action: 'login',
        lgname: username,
        lgpassword: password,
        lgtoken: get_token('login')
      }

      response = post(params)

      @assertion = assertion_value

      result = response['login']['result']

      if result == 'Success'
        @name = response['login']['lgusername']
        @logged_in = true
        return true
      end

      raise MediaWiki::Butt::AuthenticationError.new(result)
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
        token: get_token('createaccount')
      }
      params[:reason] = reason unless reason.nil?

      result = post(params)
      unless result['error'].nil?
        raise MediaWiki::Butt::AuthenticationError.new(result['error']['code'])
      end

      result['createaccount']['result'] == 'Success'
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
        token: get_token('createaccount')
      }
      params[:reason] = reason unless reason.nil?

      result = post(params)
      unless result['error'].nil?
        raise MediaWiki::Butt::AuthenticationError.new(result['error']['code'])
      end

      result['createaccount']['result'] == 'Success'
    end
  end
end
