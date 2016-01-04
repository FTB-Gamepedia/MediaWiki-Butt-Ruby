require_relative '../../../page'

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
        # @return [Array<MediaWiki::Page>] The pages that matched the search.
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
          response['query']['search'].each do |search|
            page = MediaWiki::Page.new(title: search['title'],
                                       namespace: search['ns'],
                                       snippet: search['snippet'],
                                       size: search['size'],
                                       words: search['wordcount'],
                                       time: search['timestamp'])
            ret << page
          end

          ret
        end

        # Searches the wiki by a prefix.
        # @param prefix [String] The prefix.
        # @param limit [Int] The maximum number of results to get, maximum of
        #   100 for users and 200 for bots.
        # @see https://www.mediawiki.org/wiki/API:Prefixsearch MediaWiki
        #   Prefixsearch API Docs
        # @since 0.10.0
        # @return [Array<MediaWiki::Page>] All of the pages that match the search.
        def get_prefix_search(prefix, limit = 100)
          params = {
            action: 'query',
            list: 'prefixsearch',
            pssearch: prefix,
            limit: get_limited(limit, 100, 200)
          }

          response = post(params)
          ret = []
          response['query']['prefixsearch'].each do |result|
            page = MediaWiki::Page.new(title: search['title'],
                                       namespace: search['ns'],
                                       id: search['id'])
            ret << page
          end

          ret
        end
      end
    end
  end
end
