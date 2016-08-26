require_relative '../query'

module MediaWiki
  module Query
    module Properties
      module Contributors
        # Gets the total amount of contributors for the given page.
        # @param title [String] The page title.
        # @param limit [Fixnum] The maximum number of users to get. Defaults to 500 and cannot be greater than that
        # unless the user is a bot. If the user is a bot, the limit cannot be greater than 5000.
        # @see #get_anonymous_contributors_count
        # @see #get_logged_in_contributors
        # @since 0.8.0
        # @return [Fixnum] The number of contributors to that page.
        # @return [Nil] If the page does not exist.
        def get_total_contributors(title, limit = @query_limit_default)
          anon_users = get_anonymous_contributors_count(title, limit)
          users = get_logged_in_contributors(title, limit)

          return if users.nil?
          users.size + anon_users
        end

        # Gets the non-anonymous contributors for the given page.
        # @param (see #get_total_contributors)
        # @see #get_contributors_response
        # @since 0.8.0
        # @return [Array<String>] All usernames for the contributors.
        def get_logged_in_contributors(title, limit = @query_limit_default)
          get_contributors_response(title, limit) do |return_val, query|
            pageid = nil
            query['pages'].each { |r, _| pageid = r }
            return if query['pages'][pageid].key?('missing')
            query['pages'][pageid]['contributors'].each { |c| return_val << c['name'] }
          end
        end

        private

        # Gets the parsed response for the contributors property.
        # @param (see #get_total_contributors)
        # @see https://www.mediawiki.org/wiki/API:Contributors MediaWiki Contributors Property API Docs
        # @since 0.8.0
        # @return [Hash] See {MediaWiki::Butt#query}
        def get_contributors_response(title, limit = @query_limit_default)
          params = {
            prop: 'contributors',
            titles: title,
            pclimit: get_limited(limit)
          }

          query(params) { |return_val, query| yield(return_val, query) }
        end

        # Gets the total number of anonymous contributors for the given page.
        # @param (see #get_total_contributors)
        # @see #get_contributors_response
        # @since 0.8.0
        # @return [Fixnum] The number of anonymous contributors for the page.
        # @return [Nil] If title is not a valid page.
        def get_anonymous_contributors_count(title, limit = @query_limit_default)
          ret = 0

          get_contributors_response(title, limit) do |return_val, query|
            pageid = nil
            query['pages'].each { |r, _| pageid = r }
            return if query['pages'][pageid].key?('missing')
            ret += query['pages'][pageid]['anoncontributors'].to_i
          end

          ret
        end
      end
    end
  end
end
