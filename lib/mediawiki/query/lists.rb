require_relative '../constants'
require 'string-utility'

module MediaWiki
  module Query
    module Lists
      using StringUtility

      # Gets an array of backlinks to a given title.
      # @param title [String] The page to get the backlinks of.
      # @param limit [Int] The maximum number of pages to get. Defaults to 500,
      #   and cannot be greater than that unless the user is a bot. If the user
      #   is a bot, the limit cannot be greater than 5000.
      # @return [Array] All backlinks until the limit
      def what_links_here(title, limit = 500)
        params = {
          action: 'query',
          bltitle: title
        }

        if limit > 500
          if user_bot? == true
            if limit > 5000
              params[:bllimit] = 5000
            else
              params[:bllimit] = limit
            end
          else
            params[:bllimit] = 500
          end
        else
          params[:bllimit] = limit
        end

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
          cmprop: 'title'
        }

        if category =~ /[Cc]ategory\:/
          params[:cmtitle] = category
        else
          params[:cmtitle] = "Category:#{category}"
        end

        if limit > 500
          if user_bot?
            if limit > 5000
              params[:cmlimit] = 5000
            else
              params[:cmlimit] = limit
            end
          else
            params[:cmlimit] = 500
          end
        else
          params[:cmlimit] = limit
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
          list: 'random'
        }

        if $namespaces.value?(namespace)
          params[:rnnamespace] = namespace
        else
          params[:rnnamespace] = 0
        end

        if number_of_pages > 10
          if user_bot?
            if limit > 20
              params[:rnlimit] = 20
            else
              params[:rnlimit] = limit
            end
          else
            params[:rnlimit] = 10
          end
        else
          params[:rnlimit] = number_of_pages
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
      # @return [String/Nil] Parsed full response if successful, nil if
      #   the username is nil and the Butt is not logged in.
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
      # @return [Array/Boolean] All of the user's groups, or false if username
      #   is nil and Butt is not logged in.
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
      # @return [Array/Boolean] All of the user's groups, or false if username
      #   is nil and Butt is not logged in.
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
      # @param autoparse [Boolean] Whether to automatically format the string
      #   with commas using string-utility. Defaults to true.
      # @return [Boolean/Int/String] False if username is nil and Butt is not
      #   logged in. An integer value of the contribution count if autoparse is
      #   false. A formatted string version of the contribution count if
      #   autoparse is true.
      def get_contrib_count(username = nil, autoparse = true)
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

        if autoparse
          countstring = count.to_s.separate
          return countstring
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

        if $namespaces.value?(namespace)
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

        if $namespaces.value?(namespace)
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
          list: 'allcategories'
        }

        if limit > 500
          if user_bot?
            if limit > 5000
              params[:aclimit] = 5000
            else
              params[:aclimit] = limit
            end
          else
            params[:aclimit] = 500
          end
        else
          params[:aclimit] = limit
        end

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
          list: 'allimages'
        }

        if limit > 500
          if user_bot?
            if limit > 5000
              params[:ailimit] = 5000
            else
              params[:ailimit] = limit
            end
          else
            params[:ailimit] = 500
          end
        else
          params[:ailimit] = limit
        end

        response = post(params)

        ret = []
        response['query']['allimages'].each { |i| ret.push(i['name']) }

        ret
      end
    end
  end
end
