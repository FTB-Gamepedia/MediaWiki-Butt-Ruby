module MediaWiki
  module Query
    module Lists
      module Miscellaneous
        # Returns an array of random pages titles.
        # @param namespace [Int] The namespace ID. Defaults to
        #   0 (the main namespace).
        # @see https://www.mediawiki.org/wiki/API:Random MediaWiki Random API
        #   Docs
        # @since 0.2.0
        # @return [Array] All members
        def get_random_pages(namespace = 0)
          params = {
            action: 'query',
            list: 'random',
            rnlimit: get_limited(@query_limit, 10, 20)
          }

          if MediaWiki::Constants::NAMESPACES.value?(namespace)
            params[:rnnamespace] = namespace
          else
            params[:rnnamespace] = 0
          end

          ret = []
          responce = post(params)
          responce['query']['random'].each { |a| ret << a['title'] }

          ret
        end

        # Gets the valid change tags on the wiki.
        # @see https://www.mediawiki.org/wiki/API:Tags MediaWiki Tags API Docs
        # @since 0.10.0
        # @return [Array<String>] All tag names.
        def get_tags
          params = {
            action: 'query',
            list: 'tags',
            limit: get_limited(@query_limit)
          }
          response = post(params)
          ret = []
          response['query']['tags'].each { |tag| ret << tag['name'] }
          ret
        end
      end
    end
  end
end
