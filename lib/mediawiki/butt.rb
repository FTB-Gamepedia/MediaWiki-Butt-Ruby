require_relative 'auth'
require_relative 'query/query'
require_relative 'constants'
require_relative 'edit'
require_relative 'administration'
require_relative 'watch'
require_relative 'purge'
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
    include MediaWiki::Purge

    attr_accessor :query_limit_default
    attr_accessor :use_continuation
    attr_accessor :assertion

    # Creates a new instance of MediaWiki::Butt.
    # @param url [String] The FULL wiki URL. api.php can be omitted, but it will make harsh assumptions about
    #   your wiki configuration.
    # @param opts [Hash<Symbol, Any>] The options hash for configuring this instance of Butt.
    # @option opts [String] :custom_agent A custom User-Agent to use. Optional.
    # @option opts [Fixnum] :query_limit_default The query limit to use if no limit parameter is explicitly given to
    #   the various query methods. In other words, if you pass a limit parameter to the valid query methods, it will
    #   use that, otherwise, it will use this. Defaults to 'max' to use MW's default max for each API.
    # @option opts [Boolean] :use_continuation Whether to use the continuation API on queries. Defaults to true.
    # @option opts [Symbol] :assertion If set to :user or :bot, will use the assert parameter in all requests.
    #   Setting this will open up the possibility for NotLoggedInErrors and NotBotErrors. It is important to keep in
    #   mind that methods that check if the user is logged in do not use the API, but check if the user has *ever*
    #   logged in as this Butt instance. In other words, it is a safety check for performance and not a valid API check.
    def initialize(url, opts = {})
      @url = url =~ /api.php$/ ? url : "#{url}/api.php"
      @query_limit_default = opts[:query_limit_default] || 'max'
      @client = HTTPClient.new
      @uri = URI.parse(@url)
      @logged_in = false
      @custom_agent = opts[:custom_agent]
      @use_continuation = opts[:use_continuation] || true

      assertion = opts[:assertion]
      @assertion = assertion == :user || assertion == :bot ? assertion : nil
    end

    # Performs an HTTP POST request and provides the response. This method generally should not be used by the
    # user, unless there is not a helper method provided by Butt for a particular action.
    # @param params [Hash] A hash containing MediaWiki API parameters. Please see the MediaWiki API for more
    #   information. The method automatically sets the format and assert values, unless they are specified in this
    #   hash argument.
    # @since 0.1.0
    # @return [Hash] Parsed JSON returned by the MediaWiki API
    def post(params)
      base_params = {
        format: 'json'
      }
      base_params[:assert] = @assertion.to_s if @assertion
      params = base_params.merge(params)
      header = {}
      if defined? @custom_agent
        header['User-Agent'] = @custom_agent
      else
        header['User-Agent'] = @logged_in ? "#{@name}/MediaWiki::Butt" : 'NotLoggedIn/MediaWiki::Butt'
      end

      response = JSON.parse(@client.post(@uri, params, header).body)

      if @assertion
        code = response.dig('error', 'code')
        fail MediaWiki::Butt::NotLoggedInError.new(response['error']['info']) if code == 'assertuserfailed'
        fail MediaWiki::Butt::NotBotError.new(response['error']['info']) if code == 'assertbotfailed'
      end
      response
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

    # Helper method for query methods that return a two-dimensional hashes in which the keys are not relevant to the
    #   returning value. In most cases this key is a redundant page or revision ID that is also available in the object.
    # @param (see #query_ary)
    def query_ary_irrelevant_keys(params, base_response_key, property_key)
      query(params) do |return_val, query|
        return_val.concat(query[base_response_key].values.collect { |obj| obj[property_key] })
      end
    end

    # Helper method for query methods that return an array built from the query objects.
    # @param params [Hash] A hash containing MediaWiki API parameters.
    # @param base_response_key [String] The key inside the "query" object to collect.
    # @param property_key [String] The key inside the object (under the base_response_key) to collect.
    def query_ary(params, base_response_key, property_key)
      query(params) do |return_val, query|
        return_val.concat(query[base_response_key].collect { |obj| obj[property_key] })
      end
    end

    # Gets whether the currently logged in user is a bot.
    # @return [Boolean] true if logged in as a bot, false if not logged in or
    #   logged in as a non-bot
    # @since 0.1.0 as is_current_user_bot
    # @since 0.3.0 as is_user_bot?
    # @since 0.4.1 as user_bot?
    def user_bot?
      begin
        post({ action: 'query', assert: 'bot' })
        true
      rescue MediaWiki::Butt::NotBotError
        false
      end
    end

    # Checks whether this instance is logged in.
    # @return [Boolean] true if logged in, false if not.
    def logged_in?
      begin
        post({ action: 'query', assert: 'user' })
        true
      rescue MediaWiki::Butt::NotLoggedInError
        false
      end
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
