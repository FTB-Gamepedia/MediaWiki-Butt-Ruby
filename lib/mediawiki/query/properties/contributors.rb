require_relative '../query'

module MediaWiki
  module Query
    module Properties
      module Contributors
        # Gets the total amount of contributors for the given page.
        # @param title [String] The page title.
        # @see get_anonymous_contributors_count
        # @see get_logged_in_contributors
        # @since 0.8.0
        # @return [Int] The number of contributors to that page.
        def get_total_contributors(title)
          anon_users = get_anonymous_contributors_count(title)
          users = get_logged_in_contributors(title)

          users.size + anon_users
        end

        # Gets the non-anonymous contributors for the given page.
        # @param title [String] See #get_total_contributors
        # @see get_contributors_response
        # @since 0.8.0
        # @return [Array] All usernames for the contributors.
        def get_logged_in_contributors(title)
          response = get_contributors_response(title)
          pageid = nil
          response['query']['pages'].each { |r, _| pageid = r }
          ret = []
          if response['query']['pages'][pageid]['missing'] == ''
            return nil
          else
            response['query']['pages'][pageid]['contributors'].each do |c|
              ret.push(c['name'])
            end
          end

          ret
        end

        private

        # Gets the parsed response for the contributors property.
        # @param title [String] See #get_total_contributors
        # @see https://www.mediawiki.org/wiki/API:Contributors MediaWiki
        #   Contributors Property API Docs
        # @since 0.8.0
        # @return [JSON] See #post
        def get_contributors_response(title)
          params = {
            action: 'query',
            prop: 'contributors',
            titles: title,
            pclimit: get_limited(@query_limit)
          }

          post(params)
        end

        # Gets the total number of anonymous contributors for the given page.
        # @param title [String] See #get_total_contributors
        # @see get_contributors_response
        # @since 0.8.0
        # @return [Int] The number of anonymous contributors for the page.
        def get_anonymous_contributors_count(title)
          response = get_contributors_response(title)
          pageid = nil
          response['query']['pages'].each { |r, _| pageid = r }
          return nil if response['query']['pages'][pageid]['missing'] == ''

          response['query']['pages'][pageid]['anoncontriburors'].to_i
        end
      end
    end
  end
end
