module MediaWiki
  module Extension
    module Translate
      # Gets the results from a language search.
      # It searches for every language in every language.
      # @param search [String] The search string.
      # @param typos [Int] Number of typos allowed. Optional. Web API defaults it to 1.
      # @return [Hash] The result, in format code -> name.
      def language_search(search, *typos)
        params = {
          action: 'languagesearch',
          search: search,
          format: 'json'
        }
        
        params[:typos] = typos if defined? typos
          
        response = post(params)['languagesearch']
      end
    end
  end
end
