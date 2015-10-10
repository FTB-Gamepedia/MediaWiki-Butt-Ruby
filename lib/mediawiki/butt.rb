require_relative 'auth'
require_relative 'query/query'
require_relative 'constants'
require_relative 'edit'
require_relative 'administration'
require 'httpclient'
require 'json'

module MediaWiki
  class Butt
    include MediaWiki::Auth
    include MediaWiki::Query::Meta::SiteInfo
    include MediaWiki::Query::Meta::FileRepoInfo
    include MediaWiki::Query::Meta::UserInfo
    include MediaWiki::Query::Properties
    include MediaWiki::Query::Lists
    include MediaWiki::Constants::Namespaces
    include MediaWiki::Edit
    include MediaWiki::Administration

    # Creates a new instance of MediaWiki::Butt. To work with any
    #   MediaWiki::Butt methods, you must first create an instance of it.
    # @param url [String] The FULL wiki URL. api.php can be omitted, but it
    #   will make harsh assumptions about your wiki configuration.
    # @param use_ssl [Boolean] Whether or not to use SSL. Will default to true.
    # @return [MediaWiki::Butt] new instance of MediaWiki::Butt
    def initialize(url, use_ssl = true)
      @url = url =~ /api.php$/ ? url : "#{url}/api.php"

      @client = HTTPClient.new
      @uri = URI.parse(@url)
      @ssl = use_ssl
      @logged_in = false
      @tokens = {}
    end

    # Performs a generic HTTP POST action and provides the response. This
    #   method generally should not be used by the user, unless there is not a
    #   method provided by the Butt developers for a particular action.
    # @param params [Hash] A basic hash containing MediaWiki API parameters.
    #   Please see the MediaWiki API for more information.
    # @param autoparse [Boolean] Whether or not to provide a parsed version
    #   of the response's JSON. Will default to true.
    # @param header [Hash] The header hash. Optional.
    # @return [JSON/HTTPMessage] Parsed JSON if autoparse is true, or raw
    #   response if not.
    def post(params, autoparse = true, header = nil)
      # Note that defining the header argument as a splat argument (*header)
      #   causes errors in HTTPClient. We must use header.nil? rather than a
      #   splat argument and defined? header due to this error. For those
      #   interested, the error is:
      #     undefined method `downcase' for {"Set-Cookie"=>"cookie"}:Hash
      #   This is obvisouly an error in HTTPClient, but we must work around it
      #   until there is a fix in the gem.

      params[:format] = 'json'
      header = {} if header.nil?

      if @logged_in == false
        header['User-Agent'] = 'NotLoggedIn/MediaWiki::Butt'
      else
        header['User-Agent'] = "#{@name}/MediaWiki::Butt"
      end

      res = @client.post(@uri, params, header)

      if autoparse
        return JSON.parse(res.body)
      else
        return res
      end
    end

    # Returns true if the currently logged in user is in the "bot" group.
    #   This can be helpful to some developers, but it is mostly for use
    #   internally in MediaWiki::Butt.
    # @param username [String] The username to check. Optional. Defaults to
    #   the currently logged in user if nil.
    # @return [Boolean] true if logged in as a bot, false if not logged in or
    #   logged in as a non-bot
    def user_bot?(*username)
      groups = defined? username ? get_usergroups(username) : get_usergroups

      if groups != false
        return groups.include?('bot')
      else
        return false
      end
    end
  end
end
