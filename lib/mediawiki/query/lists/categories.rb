module MediaWiki
  module Query
    module Lists
      module Categories
        # Returns an array of all page titles that belong to a given category. By default, it will only get the pages.
        # Files and subcategories can be gotten through {#get_subcategories} and {#get_files_in_category} or setting
        # the type parameter.
        # @param (see #get_subcategories)
        # @param type [String] The type of stuff to get. There are 3 valid values: page, file, and subcat. Separate
        #   these with a pipe character, e.g., 'page|file|subcat'.
        # @see https://www.mediawiki.org/wiki/API:Categorymembers MediaWiki Category Members API Docs
        # @since 0.1.0
        # @return [Array<String>] All category members until the limit
        def get_category_members(category, type = 'page', limit = @query_limit_default)
          params = {
            list: 'categorymembers',
            cmprop: 'title',
            cmlimit: get_limited(limit),
            cmtype: type
          }

          params[:cmtitle] = category =~ /[Cc]ategory:/ ? category : "Category:#{category}"

          query_ary(params, 'categorymembers', 'title')
        end

        # Gets the subcategories of a given category.
        # @param category [String] The category title. It can include "Category:", or not, it doesn't really matter
        #   because we will add it if it is missing.
        # @param limit [Fixnum] The maximum number of members to get. Defaults to query_limit_default attribute. Cannot
        #   be greater than 500 for users, 5000 for bots.
        # @see {#get_category_members}
        # @since 0.9.0
        # @return [Array<String>] All subcategories.
        def get_subcategories(category, limit = @query_limit_default)
          get_category_members(category, 'subcat', limit)
        end

        # Gets all of the files in a given category.
        # @param (see #get_subcategories)
        # @see {#get_category_members}
        # @since 0.9.0
        # @return [Array<String>] All files in the category.
        def get_files_in_category(category, limit = @query_limit_default)
          get_category_members(category, 'file', limit)
        end
      end
    end
  end
end
