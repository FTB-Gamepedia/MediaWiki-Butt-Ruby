require 'string-utility'
require_relative 'constants'

module MediaWiki
  module Query
    module Meta
      module SiteInfo
        # Gets wiki information. This method should rarely be used by
        #   normal users.
        # @param prop [String] The siprop parameter.
        # @return [Response] Parsed full response.
        def get_siteinfo(prop)
          params = {
            action: 'query',
            meta: 'siteinfo',
            siprop: prop
          }

          post(params)
        end

        # Gets the statistics for the wiki.
        # @return [Hash] The statistics and their according values.
        def get_statistics
          response = get_siteinfo('statistics')
          ret = {}
          response['query']['statistics'].each { |k, v| ret[k] = v }
          ret
        end

        # Gets the general information for the wiki.
        # @return [Hash] The general info and their according values.
        def get_general
          response = get_siteinfo('general')
          ret = {}
          response['query']['general'].each { |k, v| ret[k] = v }
          ret
        end

        # Gets all extensions installed on the wiki.
        # @return [Array] All extension names.
        def get_extensions
          response = get_siteinfo('extensions')
          ret = []
          response['query']['extensions'].each { |e| ret.push(e['name']) }
          ret
        end

        # Gets all languages and their codes.
        # @return [Hash] All languages. Hash key value pair formatted as
        #   code => name.
        def get_languages
          response = get_siteinfo('languages')
          ret = {}
          response['query']['languages'].each { |l| ret[l['code']] = l['*'] }
          ret
        end

        # Gets all namespaces on the wiki and their IDs. Different from the
        #   Namespaces module.
        # @return [Hash] All namespaces, formatted as ID => Name.
        def get_namespaces
          response = get_siteinfo('namespaces')
          ret = {}
          response['query']['namespaces'].each do |id, hash|
            idid = response['query']['namespaces'][id]['id']
            name = response['query']['namespaces'][id]['*']
            ret[idid] = name
          end
          ret
        end

        # Gets all namespace aliases and their IDs.
        # @return [Hash] All aliases, formatted as ID => Alias.
        def get_namespace_aliases
          response = get_siteinfo('namespacealiases')
          ret = {}
          response['query']['namespacealiases'].each do |a|
            ret[i['id']] = i['*']
          end
          ret
        end

        # Gets all special page aliases.
        # @return [Hash] All aliases, formatted as RealName => Alias.
        def get_special_page_aliases
          response = get_siteinfo('specialpagealiases')
          ret = {}
          response['query']['specialpagealiases'].each do |a|
            ret[i['realname']] = i['aliases']
          end
          ret
        end

        # Gets all magic words and their aliases.
        # @return [Hash] All magic words, formatted as Name => Alias.
        def get_magic_words
          response = get_siteinfo('magicwords')
          ret = {}
          response['query']['magicwords'].each do |w|
            ret[w['name']] = w['aliases']
          end
          ret
        end

        # Gets all user groups total.
        # @return [Hash] All groups, formatted as Name => [Rights].
        def get_all_usergroups
          response = get_siteinfo('usergroups')
          ret = {}
          response['query']['usergroups'].each do |g|
            ret[g['name']] = g['rights']
          end
          ret
        end

        # Gets all file extensions that are allowed to be uploaded.
        # @return [Array] All file extensions.
        def get_allowed_file_extensions
          response = get_siteinfo('fileextensions')
          ret = []
          response['query']['fileextensions'].each do |e|
            ret.push(e['ext'])
          end
          ret
        end

        # Gets the response for the restrictions siteinfo API. Not really for
        #   use by users, mostly for the other two restriction methods.
        def get_restrictions_data
          response = get_siteinfo('restrictions')
          return response['query']['restrictions']
        end

        # Gets all restriction/protection types.
        # @return [Array] All protection types.
        def get_restriction_types
          restrictions = get_restrictions_data
          ret = []
          restrictions['types'].each { |t| ret.push(t) }
          ret
        end

        # Gets all restriction/protection levels.
        # @return [Array] All protection levels.
        def get_restriction_levels
          restrictions = get_restrictions_data
          ret = []
          restrictions['levels'].each { |l| ret.push(l) }
          ret
        end

        # Gets all skins and their codes.
        # @return [Hash] All skins, formatted as Code => Name
        def get_skins
          response = get_siteinfo('skins')
          ret = {}
          response['query']['skins'].each do |s|
            ret[s['code']] = s['*']
          end
          ret
        end

        # Gets all HTML tags added by installed extensions.
        # @return [Array] All extension tags.
        def get_extension_tags
          response = get_siteinfo('extensiontags')
          ret = []
          response['query']['extensiontags'].each do |t|
            ret.push(t)
          end
          ret
        end

        # Gets all function hooks.
        # @return [Array] All function hooks.
        def get_function_hooks
          response = get_siteinfo('functionhooks')
          ret = []
          response['query']['functionhooks'].each do |h|
            ret.push(h)
          end
          ret
        end

        # Gets all variables that are usable on the wiki, such as NUMBEROFPAGES.
        # @return [Array] All variable string values.
        def get_variables
          response = get_siteinfo('variables')
          ret = []
          response['query']['variables'].each do |v|
            ret.push(v)
          end
          ret
        end
      end

      module FileRepoInfo
        # Gets FileRepoInfo for the property.
        # @param prop [String] The friprop to get.
        # @return [Response] The full parsed response.
        def get_filerepoinfo(prop)
          params = {
            action: 'query',
            meta: 'filerepoinfo',
            friprop: prop
          }

          post(params)
        end

        # Returns an array of all the wiki's file repository names.
        # @return [Array] All wiki's file repository names.
        def get_filerepo_names
          response = get_filerepoinfo('name|displayname')
          ret = {}
          response['query']['repos'].each { |n, dn| ret[n] = dn }
          ret
        end

        # Gets the root URLs for the file repositories.
        # @return [Hash] A hash containing keys of the names, and values of the
        #   root URLs.
        def get_filerepo_rooturls
          response = get_filerepoinfo('name|rootUrl')
          ret = {}
          response['query']['repos'].each { |n, r| ret[n] = r }
          ret
        end

        # Gets an array containing all local repositories.
        # @return [Array] All repositories that are marked as local.
        def get_local_filerepos
          response = get_filerepoinfo('name|local')
          ret = []
          response['query']['repos'].each do |n, l|
            ret.push(n) if l == 'true'
          end

          ret
        end

        # Gets an array containing all repositories that aren't local.
        # @return [Array] All repositories that are not marked as local.
        def get_nonlocal_filerepos
          response = get_filerepoinfo('name|local')
          ret = []
          response['query']['repos'].each do |n, l|
            ret.push(n) if l == 'false'
          end

          ret
        end

        # Gets the repository names and their according URLs.
        # @return [Hash] Names as the keys, with their URLs as the values.
        def get_filerepo_urls
          response = get_filerepoinfo('name|url')
          ret = {}
          response['query']['repos'].each { |n, u| ret[n] = u }
          ret
        end

        # Gets the repository names and their accoring thumbnail URLs.
        # @return [Hash] Names as the keys, with their URLs as the values.
        def get_filerepo_thumburls
          response = get_filerepoinfo('name|thumbUrl')
          ret = {}
          response['query']['repos'].each { |n, u| ret[n] = u }
          ret
        end

        # Gets the repository names and their according favicon URLs.
        # @return [Hash] Names as the keys, with their favicons as the values.
        def get_filerepo_favicons
          response = get_filerepoinfo('name|favicon')
          ret = {}
          response['query']['repos'].each { |n, f| ret[n] = f }
          ret
        end
      end

      module UserInfo
        # Gets meta information for the currently logged in user.
        # @param prop [String] The uiprop to get. Optional.
        # @return [Response/Boolean] Either a full, parsed response, or false if
        #   not logged in.
        def get_current_user_meta(prop = nil)
          if @logged_in
            params = {
              action: 'query',
              meta: 'userinfo',
              uiprop: prop
            }

            post(params)
          else
            return false
          end
        end

        # Gets the current user's username.
        # @return [String/Boolean] Returns the username, or false.
        def get_current_user_name
          if !@name.nil?
            return @name
          else
            name = get_current_user_meta
            if name != false
              name = name['query']['userinfo']['name']
            end

            name
          end
        end

        # Returns whether or not the currently logged in user has any unread
        #   messages on their talk page.
        # @return [Boolean] True if they have unreads, else false.
        def current_user_hasmsg?
          response = get_current_user_meta('hasmsg')
          if response != false
            if !response['query']['userinfo']['messages'] == ''
              return false
            else
              return true
            end
          else
            return false
          end
        end

        # Gets a hash-of-arrays containing all the groups the user can add and
        #   remove people from.
        # @return [Boolean/Hash] False if get_current_user_meta is false, else
        #   a hash containing arrays of all the groups the user can add/remove
        #   people from.
        def get_changeable_groups
          response = get_current_user_meta('changeablegroups')
          if response != false
            ret = {}
            add = []
            remove = []
            addself = []
            removeself = []
            changeablegroups = response['query']['userinfo']['changeablegroups']
            puts changeablegroups
            changeablegroups['add'].each { |g| puts g; add.push(g) }
            changeablegroups['remove'].each { |g| puts g; remove.push(g) }
            changeablegroups['add-self'].each { |g| puts g; addself.push(g) }
            changeablegroups['remove-self'].each { |g| puts g; removeself.push(g) }
            ret['add'] = add
            ret['remove'] = remove
            ret['addself'] = addself
            ret['removeself'] = removeself
            return ret
          else
            return false
          end
        end

        # Gets the currently logged in user's real name.
        # @return [String/Nil] Nil if they don't have a real name set, or their
        #   real name.
        def get_realname
          response = get_current_user_meta('realname')
          if response['query']['userinfo']['realname'] == ''
            return nil
          else
            return response['query']['userinfo']['realname']
          end
        end

        # Gets the currently logged in user's email address.
        # @return [String/Nil] Nil if their email is not set, or their email.
        def get_email_address
          response = get_current_user_meta('email')
          if response['query']['userinfo']['email'] == ''
            return nil
          else
            return response['query']['userinfo']['email']
          end
        end

        def get_current_user_options
          response = get_current_user_meta('options')
          ret = {}
          response['query']['userinfo']['options'].each { |k, v| ret[k] = v }
        end
      end
    end

    module Properties
      # Gets the wiki text for the given page. Returns nil if it for some
      #   reason cannot get the text, for example, if the page does not exist.
      # @param title [String] The page title
      # @return [String/nil] String containing page contents, or nil
      def get_text(title)
        params = {
          action: 'query',
          prop: 'revisions',
          rvprop: 'content',
          titles: title
        }

        response = post(params)
        revid = nil
        response['query']['pages'].each { |r, _| revid = r }

        if response['query']['pages'][revid]['missing'] == ''
          return nil
        else
          return response['query']['pages'][revid]['revisions'][0]['*']
        end
      end

      # Gets the revision ID for the given page.
      # @param title [String] The page title
      # @return [Int/nil] the ID or nil
      def get_id(title)
        params = {
          action: 'query',
          prop: 'revisions',
          rvprop: 'content',
          titles: title
        }

        response = post(params)
        response['query']['pages'].each do |revid, _|
          if revid != '-1'
            return revid.to_i
          else
            return nil
          end
        end
      end

      # Gets the token for the given type. This method should rarely be
      #   used by normal users.
      # @param type [String] The type of token.
      # @param title [String] The page title for the token. Optional.
      # @return [String] The token. If the butt isn't logged in, it returns
      #   with '+\\'.
      def get_token(type, title = nil)
        if @logged_in == true
          # There is some weird thing with MediaWiki where you must pass a valid
          #   inprop parameter in order to get any response at all. This is why
          #   there is a displaytitle inprop as well as gibberish in the titles
          #   parameter. And to avoid normalization, it's capitalized.
          params = {
            action: 'query',
            prop: 'info',
            inprop: 'displaytitle',
            intoken: type
          }

          title = 'Somegibberish' if title.nil?
          params[:titles] = title
          response = post(params)
          revid = nil
          response['query']['pages'].each { |r, _| revid = r }

          # URL encoding is not needed for some reason.
          return response['query']['pages'][revid]["#{type}token"]
        else
          return '+\\'
        end
      end
    end

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
          if is_user_bot? == true
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
          if is_user_bot?
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
          if is_user_bot?
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
    end
  end
end
