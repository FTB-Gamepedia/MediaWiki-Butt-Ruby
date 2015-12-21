module MediaWiki
  module Query
    module Lists
      module Miscellaneous
        # Returns an array of random pages titles.
        # @param number_of_pages [Int] The number of articles to get.
        #   Defaults to 1. Cannot be greater than 10 for normal users,
        #   or 20 for bots.
        # @param namespace [Int] The namespace ID. Defaults to
        #   0 (the main namespace).
        # @see https://www.mediawiki.org/wiki/API:Random MediaWiki Random API
        #   Docs
        # @since 0.2.0
        # @return [Array] All members
        def get_random_pages(number_of_pages = 1, namespace = 0)
          params = {
            action: 'query',
            list: 'random',
            rnlimit: get_limited(number_of_pages, 10, 20)
          }

          if MediaWiki::Constants::NAMESPACES.value?(namespace)
            params[:rnnamespace] = namespace
          else
            params[:rnnamespace] = 0
          end

          ret = []
          responce = post(params)
          responce['query']['random'].each { |a| ret.push(a['title']) }

          ret
        end
      end
    end
  end
end
