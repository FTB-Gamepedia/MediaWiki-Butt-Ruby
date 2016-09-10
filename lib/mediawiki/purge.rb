module MediaWiki
  module Purge
    # Purges the provided pages, without updating link tables. This will warn for every invalid purge with the reason
    # it is invalid, as provided by the MediaWiki API.
    # @param *titles [Array<String>] A list of the pages to purge.
    # @return [Hash<String, Boolean>] The key is the page title, and the value is whether it was a successful purge.
    # @see https://www.mediawiki.org/wiki/API:Purge MediaWiki API Docs
    # @note This creates a warning for every invalid purge with the reason it is invalid, as provided by the MediaWiki
    #   API, as well as the title of the invalid page.
    def purge(*titles)
      purge_request({}, titles)
    end

    # Purges the provided pages and updates their link tables.
    # @param (see #purge)
    # @return (see #purge)
    # @see (see #purge)
    # @note (see #purge)
    def purge_link_update(*titles)
      purge_request({ forcelinkupdate: 1 }, titles)
    end

    # Purges the provided pages and recursively updates the link tables.
    # @param (see #purge)
    # @return (see #purge)
    # @see (see #purge)
    # @note (see #purge)
    def purge_recursive_link_update(*titles)
      purge_request({ forcerecursivelinkupdate: 1 }, titles)
    end

    private

    # Sends a purge API request, and handles the return value and warnings.
    # @param params [Hash<Object, Object>] The parameter hash to begin with. Cannot include the titles or action keys.
    # @param (see #purge)
    # @return (see #purge)
    # @see (see #purge)
    # @note (see #purge)
    def purge_request(params, *titles)
      params[:action] = 'purge'
      params[:titles] = titles.join('|')

      response = post(params)

      ret = {}

      response['purge'].each do |hash|
        title = hash['title']
        ret[title] = hash.key?('purged') && !hash.key?('missing')
        warn "Invalid purge (#{title}) #{hash['invalidreason']}" if hash.key?('invalid')
      end

      ret
    end
  end
end
