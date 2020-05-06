module MediaWiki
  module Query
    module Lists
      module Search
        # Gets the amount of results for the search value.
        # @param (see #get_search_results)
        # @see (see #get_search_results)
        # @since 0.4.0
        # @return [Integer] The number of pages that matched the search.
        def get_search_result_amount(search_value, namespace = MediaWiki::Constants::NAMESPACES['MAIN'])
          params = {
            action: 'query',
            list: 'search',
            srsearch: search_value,
            srnamespace: validate_namespace(namespace)
          }

          response = post(params)
          response['query']['searchinfo']['totalhits']
        end

        # Gets an array containing page titles that matched the search.
        # @param search_value [String] The thing to search for.
        # @param namespace [Integer] The namespace to search in. Defaults to 0 (the main namespace).
        # @see https://www.mediawiki.org/wiki/API:Search MediaWiki Search API Docs
        # @since 0.4.0
        # @return [Array<String>] The page titles that matched the search.
        def get_search_results(search_value, namespace = MediaWiki::Constants::NAMESPACES['MAIN'])
          params = {
            list: 'search',
            srsearch: search_value,
            srnamespace: validate_namespace(namespace)
          }

          query_ary(params, 'search', 'title')
        end

        # Searches page contents, returns an array containing page titles whose content matched the search.
        # @param (see #get_search_results)
        # @see (see #get_search_results)
        # @since 4.0.0
        # @return (see #get_search_results)
        def get_search_text_results(search_value, namespace = MediaWiki::Constants::NAMESPACES['MAIN'], limit = @query_limit_default)
          params = {
            list: 'search',
            srsearch: search_value,
            srwhat: 'text',
            srlimit: get_limited(limit),
            srnamespace: validate_namespace(namespace)
          }

          query_ary(params, 'search', 'title')
        end

        # Searches the wiki by a prefix.
        # @param prefix [String] The prefix.
        # @param limit [Integer] The maximum number of results to get, maximum of 100 for users and 200 for bots. This is
        # one of the methods that does *not* use the query_limit_default attribute.
        # @see https://www.mediawiki.org/wiki/API:Prefixsearch MediaWiki Prefixsearch API Docs
        # @since 0.10.0
        # @return [Array<String>] All of the page titles that match the search.
        def get_prefix_search(prefix, limit = 100)
          params = {
            list: 'prefixsearch',
            pssearch: prefix,
            pslimit: get_limited(limit, 100, 200)
          }

          query_ary(params, 'prefixsearch', 'title')
        end
      end
    end
  end
end
