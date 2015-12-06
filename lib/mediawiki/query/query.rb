require_relative 'meta/meta'
require_relative 'lists'
require_relative 'properties/properties'

module MediaWiki
  module Query
    include MediaWiki::Query::Meta
    include MediaWiki::Query::Lists
    include MediaWiki::Query::Properties

    protected

    module_function

    # Gets the limited version of the integer, to ensure nobody provides an int
    #   that is too large.
    # @param integer [Int] The number to limit.
    # @param max_user [Int] The maximum limit for normal users.
    # @param max_bot [Int] The maximum limit for bot users.
    # @param is_user_bot [Boolean] Set to true if the user is a bot.
    # @return [Int] The capped number.
    def get_limited(integer, max_user = 500, max_bot = 5000, is_user_bot = false)
      if integer > 500
        if is_user_bot
          if integer > 5000
            return 5000
          else
            return integer
          end
        else
          return 500
        end
      else
        return integer
      end
    end
  end
end
