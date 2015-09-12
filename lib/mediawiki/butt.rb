require 'json'
require 'net/http'
require 'net/https'

module MediaWiki
  class Butt

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
    # => butt = MediaWiki::But.new("http://ftb.gamepedia.com", false)
    def initialize(url, use_ssl = true)
      if url =~ /api.php$/
        @url = url
      else
        @url = "#{url}/api.php"
      end

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
    #
    # ==== Examples
    #
    # => login = butt.action({action: 'login', lgname: username, lgpassword: password, format: 'json'})
    def action(params, autoparse = true)
      uri = URI.parse(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = @ssl
      res = http.post(uri.path, params)
      if res.is_a? Net::HTTPSuccess
        if autoparse == true
          return JSON.parse(res.body)
        else
          return res
        end
      else
        return false
      end
    end

    # Logs the user in to the wiki. This is generally required for editing, or getting restricted data.
    #
    # ==== Attributes
    # * +username+ - The desired login handle
    # * +password+ - The password of that user
    #
    # ==== Examples
    # => butt.login("MyUsername", "My5up3r53cur3P@55w0rd")
    def login(username, password)
      params = {
        action: 'login',
        lgname: username,
        lgpassword: password,
        format: 'json'
      }

      result = action(params)
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
        action(token_params)
      end
    end
  end
end
