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
        # @param limit [Int] The maximum number of members to get. Defaults to query_limit_default attribute. Cannot 
        # be greater than 500 for users, 5000 for bots.
        # @param type [String] The type of stuff to get. There are 3 valid
        #   values: page, file, and subcat. Separate these with a pipe
        #   character, e.g., 'page|file|subcat'.
        # @see https://www.mediawiki.org/wiki/API:Categorymembers MediaWiki
        #   Category Members API Docs
        # @since 0.1.0
        # @return [Array] All category members until the limit
        def get_category_members(category, limit = @query_limit_default, type = 'page')
          params = {
            action: 'query',
            list: 'categorymembers',
            cmprop: 'title',
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
          response['query']['categorymembers'].each { |cm| ret << cm['title'] }

          ret
        end

        # Gets the subcategories of a given category.
        # @param category [String] See {#get_category_members}
        # @param limit [Int] See {#get_category_members}
        # @see {#get_category_members}
        # @since 0.9.0
        # @return [Array<String>] All subcategories.
        def get_subcategories(category, limit = @query_limit_default)
          get_category_members(category, limit, 'subcat')
        end

        # Gets all of the files in a given category.
        # @param category [String] See {#get_category_members}
        # @param limit [Int] See {#get_category_members}
        # @see {#get_category_members}
        # @since 0.9.0
        # @return [Array<String>] All files in the category.
        def get_files_in_category(category, limit = @query_limit_default)
          get_category_members(category, limit, 'file')
        end
      end
    end
  end
end
