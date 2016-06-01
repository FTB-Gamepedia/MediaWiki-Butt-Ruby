module MediaWiki
  module Query
    module Lists
      module Users
        # Gets user information. This method should rarely be used by
        # normal users, unless they want a huge amount of user data at once.
        # @param prop [String] The usprop parameter.
        # @param username [String] The username to get info for. Optional.
        #   Defaults to the currently logged in user if ommitted.
        # @see https://www.mediawiki.org/wiki/API:Users MediaWiki User Lists API
        #   Docs
        # @since 0.3.0
        # @return [String] Parsed full response if successful.
        # @return [Nil] If the username is nil and the Butt is not logged in.
        def get_userlists(prop, username = nil)
          if username.nil?
            if @logged_in
              response = get_current_user_meta(prop)
            else
              return false
            end
          else
            params = {
              action: 'query',
              list: 'users',
              usprop: prop,
              ususers: username
            }

            response = post(params)
          end

          response
        end

        # Gets an array of all the user's groups.
        # @param username [String] The username to get groups of. Optional.
        #   Defaults to the currently logged in user.
        # @see get_userlists
        # @since 0.3.0
        # @return [Array] All of the user's groups.
        # @return [Boolean] False if username is nil and not logged in.
        def get_usergroups(username = nil)
          ret = []
          if username.nil?
            if @logged_in
              info = get_userlists('groups')
              info['query']['userinfo']['groups'].each { |i| ret << i }
            else
              return false
            end
          else
            info = get_userlists('groups', username)
            info['query']['users'].each do |i|
              i['groups'].each { |g| ret.push(g) }
            end
          end

          ret
        end

        # Gets the user rights for the user.
        # @param username [String] The user to get the rights for. Optional.
        #   Defaults to the currently logged in user.
        # @see get_userlists
        # @since 0.3.0
        # @return [Array] All of the user's groups.
        # @return [Boolean] False if username is nil and not logged in.
        def get_userrights(username = nil)
          ret = []
          if username.nil?
            if @logged_in
              info = get_userlists('rights')
              info['query']['userinfo']['rights'].each { |i| ret << i }
            else
              return false
            end
          else
            info = get_userlists('rights', username)
            info['query']['users'].each do |i|
              i['rights'].each do |g|
                ret.push(g)
              end
            end
          end

          ret
        end

        # Gets contribution count for the user.
        # @param username [String] The username to get the contribution count of.
        #   Optional. Defaults to the currently logged in user.
        # @see get_userlists
        # @since 0.3.0
        # @return [Boolean] False if username is nil and not logged in.
        # @return [Int] The number of contributions the user has made.
        def get_contrib_count(username = nil)
          count = nil
          if username.nil?
            if @logged_in
              info = get_userlists('editcount')
              count = info['query']['userinfo']['editcount']
            else
              return false
            end
          else
            info = get_userlists('editcount', username)
            info['query']['users'].each { |i| count = i['editcount'] }
          end

          count
        end

        # Gets when the user registered.
        # @param username [String] The username to get the registration date and
        #   time of. Optional. Defaults to the currently logged in user.
        # @see get_userlists
        # @since 0.4.0
        # @return [DateTime] The registration date and time as a DateTime object.
        # @return [Boolean] False when no username is provided and not logged in, or the user doesn't exist.
        def get_registration_time(username = nil)
          time = nil
          # Do note that in Userinfo, registration is called registrationdate.
          if username.nil?
            if @logged_in
              info = get_userlists('registrationdate')
              time = info['query']['userinfo']['registrationdate']
            else
              return false
            end
          else
            info = get_userlists('registration', username)
            info['query']['users'].each { |i| time = i['registration'] }
          end

          return false if time.nil?

          DateTime.strptime(time, '%Y-%m-%dT%T')
        end

        # Gets the gender for the provded user.
        # @param username [String] The user.
        # @see get_userlists
        # @since 0.4.0
        # @return [String] The gender. 'male', 'female', or 'unknown'.
        def get_user_gender(username)
          gender = nil
          info = get_userlists('gender', username)
          info['query']['users'].each { |i| gender = i['gender'] }

          gender
        end

        # Gets the latest contributions by the user until the limit.
        # @param user [String] The username.
        # @param limit [Int] See #get_all_images.
        # @see https://www.mediawiki.org/wiki/API:Usercontribs MediaWiki
        #   User Contributions API Docs
        # @since 0.8.0
        # @return [Hash] Each contribution by its revid, containing the title,
        #   summary, total contribution size, and the size change relative to the
        #   previous edit.
        def get_user_contributions(user, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'usercontribs',
            ucuser: user,
            uclimit: get_limited(limit),
            ucprop: 'ids|title|comment|size|sizediff|flags|patrolled'
          }

          response = post(params)

          ret = {}
          response['query']['usercontribs'].each do |item|
            ret[item['revid']] = {
              title: item['title'],
              summary: item['comment'],
              total_size: item['size'],
              diff_size: item['sizediff']
            }
          end

          ret
        end

        # Gets the user's full watchlist. If no user is provided, it will use the
        #   currently logged in user, according to the MediaWiki API.
        # @param user [String] The username.
        # @param limit [Int] See #get_all_images.
        # @see https://www.mediawiki.org/wiki/API:Watchlist MediaWiki Watchlist
        #   API Docs
        # @since 0.8.0
        # @return [Array] All the watchlist page titles.
        def get_full_watchlist(user = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'watchlist',
            wlprop: 'title',
            wllimit: get_limited(limit)
          }
          params[:wluser] = user unless user.nil?

          response = post(params)

          ret = []
          response['query']['watchlist'].each { |t| ret << t['title'] }

          ret
        end
      end
    end
  end
end
