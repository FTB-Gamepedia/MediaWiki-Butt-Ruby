module MediaWiki
  module Query
    module Lists
      module Search
        # Gets the amount of results for the search value.
        # @param search_value [String] The thing to search for.
        # @param namespace [Int] The namespace to search in.
        #   Defaults to 0 (the main namespace).
        # @see https://www.mediawiki.org/wiki/API:Search MediaWiki Search API
        #   Docs
        # @since 0.4.0
        # @return [Int] The number of pages that matched the search.
        def get_search_result_amount(search_value, namespace = 0)
          params = {
            action: 'query',
            list: 'search',
            srsearch: search_value
          }

          if MediaWiki::Constants::NAMEPSACES.value?(namespace)
            params[:srnamespace] = namespace
          else
            params[:srnamespace] = 0
          end

          response = post(params)
          response['query']['searchinfo']['totalhits']
        end

        # Gets an array containing page titles that matched the search.
        # @param search_value [String] The thing to search for.
        # @param namespace [Int] The namespace to search in.
        #   Defaults to 0 (the main namespace).
        # @see https://www.mediawiki.org/wiki/API:Search MediaWiki Search API
        #   Docs
        # @since 0.4.0
        # @return [Array] The page titles that matched the search.
        def get_search_results(search_value, namespace = 0)
          params = {
            action: 'query',
            list: 'search',
            srsearch: search_value
          }

          if MediaWiki::Constants::NAMESPACES.value?(namespace)
            params[:srnamespace] = namespace
          else
            params[:srnamespace] = 0
          end

          response = post(params)

          ret = []
          response['query']['search'].each { |search| ret<< search['title'] }

          ret
        end
      end
    end
  end
end
