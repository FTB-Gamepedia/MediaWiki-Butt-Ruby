require_relative 'contributors'
require_relative 'pages'
require_relative 'files'

module MediaWiki
  module Query
    module Properties
      include MediaWiki::Query::Properties::Contributors
      include MediaWiki::Query::Properties::Pages
      include MediaWiki::Query::Properties::Files

      # Gets the token for the given type. This method should rarely be
      #   used by normal users.
      # @param type [String] The type of token.
      # @param title [String] The page title for the token. Optional.
      # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
      # @since 0.5.0
      # @return [String] The token. If the butt isn't logged in, it returns
      #   with '+\\'.
      def get_token(type, title = nil)
        if @logged_in
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
  end
end
