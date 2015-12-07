require_relative '../constants'
require_relative 'query'

module MediaWiki
  module Query
    module Lists
      # Gets an array of backlinks to a given title.
      # @param title [String] The page to get the backlinks of.
      # @param limit [Int] The maximum number of pages to get. Defaults to 500,
      #   and cannot be greater than that unless the user is a bot. If the user
      #   is a bot, the limit cannot be greater than 5000.
      # @return [Array] All backlinks until the limit
      def what_links_here(title, limit = 500)
        params = {
          action: 'query',
          list: 'backlinks',
          bltitle: title,
          bllimit: get_limited(limit)
        }

        ret = []
        response = post(params)
        response['query']['backlinks'].each { |bl| ret.push(bl['title']) }

        ret
      end

      # Returns an array of all page titles that belong to a given category.
      # @param category [String] The category title. It can include "Category:",
      #   or not, it doesn't really matter because we will add it if it is
      #   missing.
      # @param limit [Int] The maximum number of members to get. Defaults to
      #   500, and cannot be greater than that unless the user is a bot.
      #   If the user is a bot, the limit cannot be greater than 5000.
      # @return [Array] All category members until the limit
      def get_category_members(category, limit = 500)
        params = {
          action: 'query',
          list: 'categorymembers',
          cmprop: 'title',
          cmlimit: get_limited(limit)
        }

        if category =~ /[Cc]ategory\:/
          params[:cmtitle] = category
        else
          params[:cmtitle] = "Category:#{category}"
        end
        ret = []
        response = post(params)
        response['query']['categorymembers'].each { |cm| ret.push(cm['title']) }

        ret
      end

      # Returns an array of random pages titles.
      # @param number_of_pages [Int] The number of articles to get.
      #   Defaults to 1. Cannot be greater than 10 for normal users,
      #   or 20 for bots.
      # @param namespace [Int] The namespace ID. Defaults to
      #   0 (the main namespace).
      # @return [Array] All members
      def get_random_pages(number_of_pages = 1, namespace = 0)
        params = {
          action: 'query',
          list: 'random',
          rnlimit: get_limited(number_of_pages, 10, 20)
        }

        if @namespaces.value?(namespace)
          params[:rnnamespace] = namespace
        else
          params[:rnnamespace] = 0
        end

        ret = []
        responce = post(params)
        responce['query']['random'].each { |a| ret.push(a['title']) }

        ret
      end

      # Gets user information. This method should rarely be used by
      #   normal users.
      # @param prop [String] The usprop parameter.
      # @param username [String] The username to get info for. Optional.
      #   Defaults to the currently logged in user if ommitted.
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
      # @return [Array] All of the user's groups.
      # @return [Boolean] False if username is nil and not logged in.
      def get_usergroups(username = nil)
        ret = []
        if username.nil?
          if @logged_in
            info = get_userlists('groups')
            info['query']['userinfo']['groups'].each { |i| ret.push(i) }
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
      # @return [Array] All of the user's groups.
      # @return [Boolean] False if username is nil and not logged in.
      def get_userrights(username = nil)
        ret = []
        if username.nil?
          if @logged_in
            info = get_userlists('rights')
            info['query']['userinfo']['rights'].each { |i| ret.push(i) }
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
      # @return [DateTime] The registration date and time as a DateTime object.
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

        # %Y: Year including century
        # %m: Month num
        # %d: day of month
        # %T: Time as HH:MM:SS
        timeformat = '%Y-%m-%dT%T'
        time = DateTime.strptime(time, timeformat)

        time
      end

      # Gets the gender for the provded user.
      # @param username [String] The user.
      # @return [String] The gender. 'male', 'female', or 'unknown'.
      def get_user_gender(username)
        gender = nil
        info = get_userlists('gender', username)
        info['query']['users'].each { |i| gender = i['gender'] }

        gender
      end

      # Gets the amount of results for the search value.
      # @param search_value [String] The thing to search for.
      # @param namespace [Int] The namespace to search in.
      #   Defaults to 0 (the main namespace).
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
        response['query']['search'].each { |search| ret.push(search['title']) }

        ret
      end

      # Gets all categories on the entire wiki.
      # @param limit [Int] The maximum number of categories to get. Defaults to
      #   500. Cannot be greater than 500 for normal users, or 5000 for bots.
      # @return [Array] An array of all categories.
      def get_all_categories(limit = 500)
        params = {
          action: 'query',
          list: 'allcategories',
          aclimit: get_limited(limit)
        }

        response = post(params)

        ret = []
        response['query']['allcategories'].each { |c| ret.push(c['*']) }

        ret
      end

      # Gets all the images on the wiki.
      # @param limit [Int] The maximum number of images to get. Defaults to 500.
      #   Cannot be greater than 500 for normal users, or 5000 for bots.
      # @return [Array] An array of all images.
      def get_all_images(limit = 500)
        params = {
          action: 'query',
          list: 'allimages',
          ailimit: get_limited(limit)
        }

        response = post(params)

        ret = []
        response['query']['allimages'].each { |i| ret.push(i['name']) }

        ret
      end

      # Gets all pages within a namespace integer.
      # @param namespace [Int] The namespace ID.
      # @param limit [Int] See #get_all_images
      # @return [Array] An array of all page titles.
      def get_all_pages_in_namespace(namespace, limit = 500)
        params = {
          action: 'query',
          list: 'allpages',
          apnamespace: namespace,
          aplimit: get_limited(limit)
        }

        response = post(params)

        ret = []
        response['query']['allpages'].each { |p| ret.push(p['title']) }

        ret
      end

      # Gets all users, or all users in a group.
      # @param group [String] The group to limit this query to.
      # @param limit [Int] See #get_all_images.
      # @return [Hash] A hash of all users, names are keys, IDs are values.
      def get_all_users(group = nil, limit = 500)
        params = {
          action: 'query',
          list: 'allusers',
          aulimit: get_limited(limit)
        }
        params[:augroup] = group unless group.nil?

        response = post(params)

        ret = {}
        response['query']['allusers'].each { |u| ret[u['name']] = u['userid'] }

        ret
      end

      # Gets all block IDs on the wiki. It seems like this only gets non-IP
      #   blocks, but the MediaWiki docs are a bit unclear.
      # @param limit [Int] See #get_all_images.
      # @return [Array] All block IDs as strings.
      def get_all_blocks(limit = 500)
        params = {
          action: 'query',
          list: 'blocks',
          bklimit: get_limited(limit),
          bkprop: 'id'
        }

        response = post(params)

        ret = []
        response['query']['blocks'].each { |b| ret.push(b['id']) }

        ret
      end

      # Gets all page titles that transclude a given page.
      # @param page [String] The page name.
      # @param limit [Int] See #get_all_images.
      # @return [Array] All transcluder page titles.
      def get_all_transcluders(page, limit = 500)
        params = {
          action: 'query',
          list: 'embeddedin',
          eititle: page,
          eilimit: get_limited(limit)
        }

        response = post(params)

        ret = []
        response['query']['embeddedin'].each { |e| ret.push(e['title']) }

        ret
      end

      # Gets an array of all deleted or archived files on the wiki.
      # @param limit [Int] See #get_all_images
      # @return [Array] All deleted file names. These are not titles, so they do
      #   not include "File:".
      def get_all_deleted_files(limit = 500)
        params = {
          action: 'query',
          list: 'filearchive',
          falimit: get_limited(limit)
        }

        response = post(params)

        ret = []
        response['query']['filearchive'].each { |f| ret.push(f['name']) }

        ret
      end

      # Gets a list of all protected pages, by protection level if provided.
      # @param protection_level [String] The protection level, e.g., sysop
      # @param limit [Int] See #get_all_images.
      # @return [Array] All protected page titles.
      def get_all_protected_titles(protection_level = nil, limit = 500)
        params = {
          action: 'query',
          list: 'protectedtitles',
          ptlimit: get_limited(limit)
        }
        params[:ptlevel] = protection_level unless protection_level.nil?

        response = post(params)

        ret = []
        response['query']['protectedtitles'].each { |t| ret.push(t['title']) }

        ret
      end

      # Gets the latest contributions by the user until the limit.
      # @param user [String] The username.
      # @param limit [Int] See #get_all_images.
      # @return [Hash] Each contribution by its revid, containing the title,
      #   summary, total contribution size, and the size change relative to the
      #   previous edit.
      def get_user_contributions(user, limit = 500)
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
      # @return [Array] All the watchlist page titles.
      def get_full_watchlist(user = nil, limit = 500)
        params = {
          action: 'query',
          list: 'watchlist',
          wlprop: 'title'
        }
        params[:wluser] = user unless user.nil?

        response = post(params)

        ret = []
        response['query']['watchlist'].each { |t| ret.push(t['title']) }

        ret
      end
    end
  end
end
