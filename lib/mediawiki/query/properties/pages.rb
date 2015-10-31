module MediaWiki
  module Query
    module Properties
      module Pages
        # Gets all categories in the page.
        # @param title [String] The page title.
        # @return [Array] All the categories
        # @return [Nil] If the title does not exist.
        def get_categories_in_page(title)
          params = {
            action: 'query',
            prop: 'categories',
            titles: title
          }

          response = post(params)
          pageid = nil
          ret = []
          response['query']['pages'].each { |r, _| pageid = r }
          if response['query']['pages'][pageid]['missing'] == ''
            return nil
          else
            response['query']['pages'][pageid]['categories'].each do |c|
              ret.push(c['title'])
            end
          end

          ret
        end

        # Gets the wiki text for the given page. Returns nil if it for some
        #   reason cannot get the text, for example, if the page does not exist.
        # @param title [String] The page title
        # @return [String/nil] String containing page contents.
        # @return [Nil] If the page does not exist.
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
        # @return [Int/nil] The page's ID
        # @return [Nil] If the page does not exist.
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
      end
    end
  end
end
