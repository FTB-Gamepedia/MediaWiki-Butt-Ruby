module MediaWiki
  module Extension
    module Translate
      # Gets the results from a language search.
      # It searches for every language in every language.
      # @param search [String] The search string.
      # @param typos [Int] Number of typos allowed. Optional.
      # @return [Hash] The result, in format code -> name.
      def language_search(search, typos = 1)
        params = {
          action: 'languagesearch',
          search: search,
          typos: typos
        }

        response = post(params)['languagesearch']
      end
    end
  end
end
