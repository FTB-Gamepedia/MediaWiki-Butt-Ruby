require_relative 'siteinfo'
require_relative 'filerepoinfo'
require_relative 'userinfo'

module MediaWiki
  module Query
    module Meta
      include MediaWiki::Query::Meta::UserInfo
      include MediaWiki::Query::Meta::FileRepoInfo
      include MediaWiki::Query::Meta::UserInfo

      # All valid types of tokens. Taken from API:Tokens on MediaWiki.
      TOKEN_TYPES = %w(csrf watch patrol rollback userrights login createaccount)

      # Obtains a token for the current user (or lack thereof) for specific actions. This uses the functionality
      # introduced in MediaWiki 1.27
      # @param type [String, Array<String>] The type of token to get. See #TOKEN_TYPES to see the valid types. If it
      #   is invalid, it will default to 'csrf'. If it is an array, it will join by a pipe for the API.
      # @return [String, Hash<String => String>] Either a token or a set of tokens organized by type. If multiple
      #   valid types are provided in the parameter, it returns a hash identical to the API response (see API docs).
      def get_token(type = 'csrf')
        params = {
          action: 'query',
          meta: 'tokens'
        }

        if type.is_a?(Array)
          type = (type - TOKEN_TYPES).empty? ? type.join('|') : 'csrf'
        else
          type = TOKEN_TYPES.include?(type) ? type : 'csrf'
        end
        params[:type] = type

        resp = post(params)
        tokens = resp['query']['tokens']
        tokens.size > 1 ? tokens : tokens["#{type}token"]
      end
    end
  end
end
