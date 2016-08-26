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
    attr_accessor :use_continuation

    # Creates a new instance of MediaWiki::Butt.
    # @param url [String] The FULL wiki URL. api.php can be omitted, but it will make harsh assumptions about
    #   your wiki configuration.
    # @param opts [Hash<Symbol, Any>] The options hash for configuring this instance of Butt.
    # @option opts [String] :custom_agent A custom User-Agent to use. Optional.
    # @option opts [Fixnum] :query_limit_default The query limit to use if no limit parameter is explicitly given to
    #   the various query methods. In other words, if you pass a limit parameter to the valid query methods, it will
    #   use that, otherwise, it will use this. Defaults to 500. It can be set to 'max' to use MW's default max for
    #   each API.
    # @option opts [Boolean] :use_continuation Whether to use the continuation API on queries.
    def initialize(url, opts = {})
      @url = url =~ /api.php$/ ? url : "#{url}/api.php"
      @query_limit_default = opts[:query_limit_default] || 500
      @client = HTTPClient.new
      @uri = URI.parse(@url)
      @logged_in = false
      @custom_agent = opts[:custom_agent]
      @use_continuation = opts[:use_continuation]
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

    # Performs a Mediawiki API query and provides the response, dealing with continuation as necessary.
    # @param params [Hash] A hash containing MediaWiki API parameters.
    # @param base_return [Any] The return value to start with. Defaults to an empty array.
    # @yield [base_return, query] Provides the value provided to the base_return parameter, and the value in the
    #   'query' key in the API response. See the API documentation for more information on this. If the base_return
    #   value is modified in the block, its modifications will persist across each continuation loop.
    # @return [Any] The base_return value as modified by the yielded block.
    def query(params, base_return = [])
      params[:action] = 'query'
      params[:continue] = ''

      loop do
        result = post(params)
        yield(base_return, result['query']) if result.key?('query')
        break unless @use_continuation
        break unless result.key?('continue')
        continue = result['continue']
        continue.each do |key, val|
          params[key.to_sym] = val
        end
      end

      base_return
    end

    # Helper method for query methods that return an array built from the query objects.
    # @param params [Hash] A hash containing MediaWiki API parameters.
    # @param
    def query_ary(params, base_response_key, property_key)
      p params
      query(params) do |return_val, query|
        p query[base_response_key]
        query[base_response_key].each { |obj| return_val << obj[property_key] }
      end
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
      if integer.is_a?(String)
        return integer if integer == 'max'
        return 500
      end
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
