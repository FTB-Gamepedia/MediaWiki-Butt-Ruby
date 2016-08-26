module MediaWiki
  module Query
    module Lists
      module Miscellaneous
        # Returns an array of random pages titles.
        # @param limit [Fixnum] The number of articles to get. Defaults to 1. Cannot be greater than 10 for normal
        #   users, or 20 for bots. This method does *not* use the query_limit_default attribute. This method does not
        #   use continuation.
        # @param namespace [Fixnum] The namespace ID. Defaults to 0 (the main namespace).
        # @see https://www.mediawiki.org/wiki/API:Random MediaWiki Random API Docs
        # @since 0.2.0
        # @return [Array<String>] All members
        def get_random_pages(limit = 1, namespace = 0)
          params = {
            list: 'random',
            rnlimit: get_limited(limit, 10, 20),
            rnnamespace: validate_namespace(namespace)
          }

          continue = @use_continuation
          @use_continuation = false
          ret = query_ary(params, 'random', 'title')
          @use_continuation = continue
          ret
        end

        # Gets the valid change tags on the wiki.
        # @param limit [Fixnum] The maximum number of results to get. Maximum 5000 for bots and 500 for users.
        # @see https://www.mediawiki.org/wiki/API:Tags MediaWiki Tags API Docs
        # @since 0.10.0
        # @return [Array<String>] All tag names.
        def get_tags(limit = @query_limit_default)
          params = {
            list: 'tags',
            limit: get_limited(limit)
          }

          query_ary(params, 'tags', 'name')
        end
      end
    end
  end
end
