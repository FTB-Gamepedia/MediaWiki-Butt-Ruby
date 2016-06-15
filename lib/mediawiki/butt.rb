require_relative 'auth'
require_relative 'query/query'
require_relative 'constants'
require_relative 'edit'
require_relative 'administration'
require_relative 'watch'
require 'httpclient'
require 'json'

module MediaWiki
  class Butt
    include MediaWiki::Auth
    include MediaWiki::Query
    include MediaWiki::Query::Meta::SiteInfo
    include MediaWiki::Query::Meta::FileRepoInfo
    include MediaWiki::Query::Meta::UserInfo
    include MediaWiki::Query::Properties
    include MediaWiki::Query::Lists
    include MediaWiki::Constants
    include MediaWiki::Edit
    include MediaWiki::Administration
    include MediaWiki::Watch

    attr_accessor :query_limit_default

    # Creates a new instance of MediaWiki::Butt.
    # @param url [String] The FULL wiki URL. api.php can be omitted, but it will make harsh assumptions about
    #   your wiki configuration.
    # @param opts [Hash<Symbol, Any>] The options hash for configuring this instance of Butt.
    # @option opts [String] :custom_agent A custom User-Agent to use. Optional.
    # @option opts [Fixnum] :query_limit_default The query limit to use if no limit parameter is explicitly given to
    #   the various query methods. In other words, if you pass a limit parameter to the valid query methods, it will
    #   use that, otherwise, it will use this. Defaults to 500.
    def initialize(url, opts = {})
      @url = url =~ /api.php$/ ? url : "#{url}/api.php"
      @query_limit_default = opts[:query_limit_default] || 500
      @client = HTTPClient.new
      @uri = URI.parse(@url)
      @logged_in = false
      @custom_agent = opts[:custom_agent]
    end

    # Performs a generic HTTP POST request and provides the response. This method generally should not be used by the
    # user, unless there is not a helper method provided by Butt for a particular action.
    # @param params [Hash] A basic hash containing MediaWiki API parameters. Please see the MediaWiki API for more
    #   information.
    # @param autoparse [Boolean] Whether or not to provide a parsed version of the response's JSON.
    # @param header [Hash] The header hash. Optional.
    # @since 0.1.0
    # @return [Hash] Parsed JSON if autoparse is true.
    # @return [HTTPMessage] Raw HTTP response if autoparse is not true.
    def post(params, autoparse = true, header = nil)
      params[:format] = 'json'
      header = {} if header.nil?

      header['User-Agent'] = @logged_in ? "#{@name}/MediaWiki::Butt" : 'NotLoggedIn/MediaWiki::Butt'
      header['User-Agent'] = @custom_agent if defined? @custom_agent

      res = @client.post(@uri, params, header)

      autoparse ? JSON.parse(res.body) : res
    end

    # Gets whether the currently logged in user is a bot.
    # @param username [String] The username to check. Optional. Defaults to
    #   the currently logged in user if nil.
    # @return [Boolean] true if logged in as a bot, false if not logged in or
    #   logged in as a non-bot
    # @since 0.1.0 as is_current_user_bot
    # @since 0.3.0 as is_user_bot?
    # @since 0.4.1 as user_bot?
    def user_bot?(username = nil)
      groups = false
      name = username || @name
      groups = get_usergroups(name) if name
      groups && groups.include?('bot')
    end

    protected

    # Gets the limited version of the integer, to ensure nobody provides an int that is too large.
    # @param integer [Fixnum] The number to limit.
    # @param max_user [Fixnum] The maximum limit for normal users.
    # @param max_bot [Fixnum] The maximum limit for bot users.
    # @since 0.8.0
    # @return [Fixnum] The capped number.
    def get_limited(integer, max_user = 500, max_bot = 5000)
      return integer if integer <= max_user

      if user_bot?
        integer > max_bot ? max_bot : integer
      else
        max_user
      end
    end

    # Safely validates the given namespace ID, and returns 0 for the main namespace if invalid.
    # @param namespace [Fixnum] The namespace ID.
    # @return [Fixnum] Either the given namespace, if valid, or the main namespace ID 0 if invalid.
    def validate_namespace(namespace)
      MediaWiki::Constants::NAMESPACES.value?(namespace) ? namespace : 0
    end
  end
end
