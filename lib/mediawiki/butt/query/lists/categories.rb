require_relative '../../../page'

module MediaWiki
  module Query
    module Lists
      module Categories
        # Returns an array of all page titles that belong to a given category.
        #   By default, it will only get the pages. Files and subcategories can
        #   be gotten through {#get_subcategories} and {#get_files_in_category}
        #   or setting the type parameter.
        # @param category [String] The category title. It can include
        #   "Category:", or not, it doesn't really matter because we will add it
        #   if it is missing.
        # @param limit [Int] The maximum number of members to get. Defaults to
        #   500, and cannot be greater than that unless the user is a bot.
        #   If the user is a bot, the limit cannot be greater than 5000.
        # @param type [String] The type of stuff to get. There are 3 valid
        #   values: page, file, and subcat. Separate these with a pipe
        #   character, e.g., 'page|file|subcat'.
        # @see https://www.mediawiki.org/wiki/API:Categorymembers MediaWiki
        #   Category Members API Docs
        # @since 0.1.0
        # @return [Array<MediaWiki::Page>] All category members until the limit
        def get_category_members(category, limit = 500, type = 'page')
          params = {
            action: 'query',
            list: 'categorymembers',
            cmlimit: get_limited(limit),
            cmtype: type
          }

          if category =~ /[Cc]ategory\:/
            params[:cmtitle] = category
          else
            params[:cmtitle] = "Category:#{category}"
          end
          ret = []
          response = post(params)
          response['query']['categorymembers'].each do |cm|
            page = MediaWiki::Page.new(title: cm['title'], id: cm['pageid'], namespace: cm['ns'])
            ret << page
          end

          ret
        end

        # Gets the subcategories of a given category.
        # @param category [String] See {#get_category_members}
        # @param limit [Int] See {#get_category_members}
        # @see {#get_category_members}
        # @since 0.9.0
        # @return [Array<String>] All subcategories.
        def get_subcategories(category, limit = 500)
          get_category_members(category, limit, 'subcat')
        end

        # Gets all of the files in a given category.
        # @param category [String] See {#get_category_members}
        # @param limit [Int] See {#get_category_members}
        # @see {#get_category_members}
        # @since 0.9.0
        # @return [Array<String>] All files in the category.
        def get_files_in_category(category, limit = 500)
          get_category_members(category, limit, 'file')
        end
      end
    end
  end
end
