require_relative 'auth'
require_relative 'query'
require 'httpclient'
require 'json'

module MediaWiki
  class Butt
    include MediaWiki::Auth
    include MediaWiki::Query::Meta
    include MediaWiki::Query::Properties
    include MediaWiki::Query::Lists
    # Creates a new instance of MediaWiki::Butt
    #
    # ==== Attributes
    #
    # * +url+ - The FULL wiki URL. api.php can be omitted, but it will make harsh assumptions about your wiki configuration.
    # * +use_ssl+ - Whether or not to use SSL. Will default to true.
    #
    # ==== Examples
    #
    # The example below shows an ideal usage of the method.
    # => butt = MediaWiki::Butt.new("http://ftb.gamepedia.com/api.php")
    #
    # The example below shows a less than idea, but still functional, usage of the method. It is less than ideal because it has to assume that your API page is at /api.php, but it could easily be at /w/api.php, or even /wiki/api.php. It also does not use a secure connection.
    # => butt = MediaWiki::Butt.new("http://ftb.gamepedia.com", false)
    def initialize(url, use_ssl = true)
      if url =~ /api.php$/
        @url = url
      else
        @url = "#{url}/api.php"
      end

      @client = HTTPClient.new
      @uri = URI.parse(@url)
      @ssl = use_ssl
      @logged_in = false
      @tokens = {}
    end

    # Performs a generic HTTP POST action and provides the response. This method generally should not be used by the user, unless there is not a method provided by the Butt developers for a particular action.
    #
    # ==== Attributes
    #
    # * +params+ - A basic hash containing MediaWiki API parameters. Please see mediawiki.org/wiki/API for more information.
    # * +autoparse+ - Whether or not to provide a parsed version of the response's JSON. Will default to true.
    # * +setcookie+ - Whether you want to set the auth cookie. Only used in authentication. Defaults to false.
    #
    # ==== Examples
    #
    # => login = butt.post({action: 'login', lgname: username, lgpassword: password, format: 'json'})
    def post(params, autoparse = true, setcookie = false)
      if setcookie == true
        header = { 'Set-Cookie' => @cookie }
        response = @client.post(@uri, params, header)
      else
        response = @client.post(@uri, params)
      end

      if autoparse == true
        return JSON.parse(response.body)
      else
        return response
      end
    end

    # Returns true if the currently logged in user is in the "bot" group.
    # Will return false if the user is either not a bot or if they are not logged in.
    def is_current_user_bot()
      if @logged_in == true
        params = {
          action: 'query',
          meta: 'userinfo',
          uiprop: 'groups',
          format: 'json'
        }

        ret = Array.new
        response = post(params)
        response["query"]["userinfo"]["groups"].each do |g|
          if g == "bot"
            return true
          else
            next
          end
        end
        return false
      else
        return false
      end
    end
  end
end
