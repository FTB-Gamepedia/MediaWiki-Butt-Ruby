module MediaWiki
  module Query
    module Properties
      module Contributors
        # Gets the total amount of contributors for the given page.
        # @param title [String] The page title.
        # @param limit [Int] The maximum number of users to get. Defaults to 500,
        #   and cannot be greater than that unless the user is a bot. If the user
        #   is a bot, the limit cannot be greater than 5000.
        # @return [Int] The number of contributors to that page.
        def get_total_contributors(title, limit = 500)
          anon_users = get_anonymous_contributors_count(title, limit)
          users = get_logged_in_contributors(title, limit)
          return users.size + anon_users
        end

        # Gets the non-anonymous contributors for the given page.
        # @param title [String] See #get_total_contributors
        # @param limit [Int] See #get_total_contributors
        # @return [Array] All usernames for the contributors.
        def get_logged_in_contributors(title, limit = 500)
          response = get_contributors_response(title, limit)
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
        # @param limit [Int] See #get_total_contributors
        # @return [JSON] See #post
        def get_contributors_response(title, limit = 500)
          params = {
            action: 'query',
            prop: 'contributors',
            titles: title,
            pclimit: MediaWiki::Query.get_limited(limit)
          }

          post(params)
        end

        # Gets the total number of anonymous contributors for the given page.
        # @param title [String] See #get_total_contributors
        # @param limit [Int] See #get_total_contributors
        # @return [Int] The number of anonymous contributors for the page.
        def get_anonymous_contributors_count(title, limit = 500)
          response = get_contributors_response(title, limit)
          pageid = nil
          response['query']['pages'].each { |r, _| pageid = r }
          return nil if response['query']['pages'][pageid]['missing'] == ''

          response['query']['pages'][pageid]['anoncontriburors'].to_i
        end
      end
    end
  end
end
