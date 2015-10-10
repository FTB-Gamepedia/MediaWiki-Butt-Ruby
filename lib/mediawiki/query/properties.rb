module MediaWiki
  module Query
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

      # Gets all categories in the page.
      # @param title [String] The page title.
      # @return [Array/Nil] An array of all the categories, or nil if the title
      #   is not an actual page.
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
    end
  end
end
