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
      # @param type [String] The type of token to get. See #TOKEN_TYPES to see the valid types. If it is invalid, it
      #   will default to 'csrf'.
      # @return [String] A token for the provided type.
      def get_token(type = 'csrf')
        type = 'csrf' unless TOKEN_TYPES.include?(type)

        return @tokens[type] if @tokens.key?(type)

        params = {
          action: 'query',
          meta: 'tokens',
          type: type
        }

        resp = post(params)
        tokens = resp['query']['tokens']
        token = tokens["#{type}token"]
        @tokens[type] = token
        token
      end
    end
  end
end
