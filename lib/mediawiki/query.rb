module MediaWiki
  module Query
    #TODO: Actually decide on a good way to deal with meta information queries.
    # The metainformation could probably be handled in a much less verbose way.
    module Meta

      # Gets all raw names for the wiki's image repositories into an array.
      #
      # ==== Examples
      #
      # => names = butt.get_filerepo_names()
      def get_filerepo_names()
        params = {
          action: 'query',
          meta: 'filerepoinfo',
          friprop: 'name',
          format: 'json'
        }

        result = post(params)
        array = Array.new
        result["query"]["repos"].each do |repo|
          array.push(repo["name"])
        end
        return array
      end
    end

    module Properties

      # Gets the text for the given page. Returns nil if the page does not exist.
      #
      # ==== Attributes
      #
      # * +title+ - The page.
      #
      # ==== Examples
      #
      # => text = butt.get_text("User:Pendejo")
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
    end

    module Lists
      # Gets the list of backlinks of the title.
      #
      # ==== Attributes
      #
      # * +title+ - List pages linking to this title.
      # * +limit+ - The maximum number of pages to get. Defaults to 500, and cannot be greater than 5000.
      #
      # ==== Examples
      #
      # => backlinks = butt.what_links_here("Title", 5)
      # => backlinks.each do |butt|
      # =>   puts butt
      # => end
      def what_links_here(title, limit = 500)
        params = {
          action: 'query',
          bltitle: title,
          format: 'json'
        }

        if limit > 500
          if is_current_user_bot() == true
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
      # Returns an array of all pages (titles specifically, because IDs and namespace ints aren't very important) that belong to a given category. See API:Categorymembers
      #
      # ==== Attributes
      #
      # * +category+ - The category title.
      # * +limit+ - The maximum number of members to get. Defaults to 500, and cannot be greater than 5000.
      #
      # ==== Examples
      #
      # => members = butt.get_category_members("Category:Butts", 5000)
      # => members.each do |butts|
      # =>   puts butts
      # => end
      def get_category_members(category, limit = 500)
        params = {
          action: 'query',
          list: 'categorymembers',
          #cmprop: 'title',
          format: 'json'
        }

        if category =~ /Category\:/
          params[:cmtitle] = category
        else
          params[:cmtitle] = "Category:#{category}"
        end

        if limit > 500
          if is_current_user_bot() == true
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
    end
  end
end
