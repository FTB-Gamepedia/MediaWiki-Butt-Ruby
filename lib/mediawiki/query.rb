require 'string-utility'

module MediaWiki
  module Query
    #TODO: Actually decide on a good way to deal with meta information queries.
    # The metainformation could probably be handled in a much less verbose way.
    module Meta

      # Returns an array of all the wiki's file repository names.
      # @return [Array] All wiki's file repository names.
      def get_filerepo_names
        params = {
          action: 'query',
          meta: 'filerepoinfo',
          friprop: 'name',
          format: 'json'
        }

        result = post(params)
        ret = Array.new
        result["query"]["repos"].each do |repo|
          ret.push(repo["name"])
        end
        return ret
      end
    end

    module Properties

      # Gets the wiki text for the given page. Returns nil if it for some reason cannot get the text, for example, if the page does not exist. Returns a string.
      # @param title [String] The page title
      # @return [String/nil] String containing page contents, or nil
      def get_text(title)
        params = {
          action: 'query',
          prop: 'revisions',
          rvprop: 'content',
          format: 'json',
          titles: title
        }

        response = post(params)
        response["query"]["pages"].each do |revid, data|
          $revid = revid
        end

        if response["query"]["pages"][$revid]["missing"] == ""
          return nil
        else
          return response["query"]["pages"][$revid]["revisions"][0]["*"]
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
          format: 'json',
          titles: title
        }

        response = post(params)
        response["query"]["pages"].each do |revid, data|
          if revid != "-1"
            return revid.to_i
          else
            return nil
          end
        end
      end

      # Gets the edit token for the given page. This method should rarely be used by normal users.
      # @param page_name [String] The page title that you are going to be editing.
      # @return [String] The edit token. If the butt isn't logged in, it returns with '+\\'.
      def get_edit_token(page_name)
        if @logged_in == true
          params = {
            action: 'query',
            prop: 'info',
            intoken: 'edit',
            format: 'json',
            titles: page_name
          }

          response = post(params)
          response["query"]["pages"].each do |revid, data|
            $revid = revid
          end

          # URL encoding is not needed for some reason.
          return response["query"]["pages"][$revid]["edittoken"]
        else
          return "+\\"
        end
      end
    end

    module Lists

      # Gets an array of backlinks to a given title.
      # @param title [String] The page to get the backlinks of.
      # @param limit [Int] The maximum number of pages to get. Defaults to 500, and cannot be greater than that unless the user is a bot. If the user is a bot, the limit cannot be greater than 5000.
      # @return [Array] All backlinks until the limit
      def what_links_here(title, limit = 500)
        params = {
          action: 'query',
          bltitle: title,
          format: 'json'
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

        ret = Array.new
        response = post(params)
        response["query"]["backlinks"].each do |bl|
          ret.push(bl["title"])
        end
        return ret
      end

      # Returns an array of all page titles that belong to a given category.
      # @param category [String] The category title. It can include "Category:", or not, it doesn't really matter because we will add it if it is missing.
      # @param limit [Int] The maximum number of members to get. Defaults to 500, and cannot be greater than that unless the user is a bot. If the user is a bot, the limit cannot be greater than 5000.
      # @return [Array] All category members until the limit
      def get_category_members(category, limit = 500)
        params = {
          action: 'query',
          list: 'categorymembers',
          cmprop: 'title',
          format: 'json'
        }

        if category =~ /[Cc]ategory\:/
          params[:cmtitle] = category
        else
          params[:cmtitle] = "Category:#{category}"
        end

        if limit > 500
          if is_user_bot? == true
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

        ret = Array.new
        response = post(params)
        response["query"]["categorymembers"].each do |cm|
          ret.push(cm["title"])
        end
        return ret
      end

      # Returns an array of random pages titles.
      # @param number_of_pages [Int] The number of articles to get. Defaults to 1. Cannot be greater than 10 for normal users, or 20 for bots.
      # @param namespace [Int] The namespace ID. Defaults to '0' (the main namespace). Set to nil for all namespaces.
      # @return [Array] All members
      def get_random_pages(number_of_pages = 1, namespace = 0)
        params = {
          action: 'query',
          list: 'random',
          format: 'json'
        }

        params[:rnnamespace] = namespace if namespace != nil

        if namespace > 10
          if is_user_bot? == true
            if limit > 20
              params[:rnlimit] = 20
            else
              params[:rnlimit] = limit
            end
          else
            params[:rnlimit] = 10
          end
        else
          params[:rnlimit] = namespace
        end

        ret = Array.new
        responce = post(params)
        responce["query"]["random"].each do |a|
          ret.push(a["title"])
        end
        return ret
      end

      # Gets user information. This method should rarely be used by normal users.
      # @param prop [String] The usprop parameter.
      # @param username [String] The username to get info for. Optional. Defaults to the currently logged in user if ommitted.
      # @return [String/Nil] Parsed full response if successful, nil if the username is nil and the Butt is not logged in.
      def get_userlists(prop, username = nil)
        params = {
          action: 'query',
          list: 'users',
          usprop: prop,
          format: 'json'
        }

        if username.nil?
          if @logged_in == true
            response = post(params)
          else
            return nil
          end
        else
          params[:ususers] = username
          response = post(params)
        end

        return response
      end

      # Gets an array of all the currently logged in user's groups.
      # @param username [String] The username to get groups of. Optional. Defaults to the currently logged in user.
      # @return [Array/Boolean] All of the user's groups, or false if username is nil and Butt is not logged in.
      def get_usergroups(username = nil)
        if username.nil?
          if @logged_in == true
            info = get_userlists('groups')
          else
            return false
          end
        else
          info = get_userlists('groups', username)
        end

        ret = Array.new
        info["query"]["users"].each do |i|
          i["groups"].each do |g|
            ret.push(g)
          end
        end
        return ret
      end

      # Gets contribution count for the user.
      # @param username [String] The username to get the contribution count of. Optional. Defaults to the currently logged in user.
      # @param autoparse [Boolean] Whether to automatically format the string with commas. Defaults to true.
      # @return [Boolean/Int/String] False if username is nil and Butt is not logged in. An integer value of the contribution count if autoparse is false. A formatted string version of the contribution count if autoparse is true.
      def get_contrib_count(username = nil, autoparse = true)
        if username.nil?
          if @logged_in == true
            info = get_userlists('editcount')
          else
            return false
          end
        else
          info = get_userlists('editcount', username)
        end

        count = nil
        info["query"]["users"].each do |i|
          count = i["editcount"]
        end

        if autoparse == true
          countstring = StringUtility.separate_with(count.to_s)
          return countstring
        end
        return count
      end
    end
  end
end
