require_relative 'meta/meta'
require_relative 'lists/lists'
require_relative 'properties/properties'

module MediaWiki
  module Query
    include MediaWiki::Query::Meta
    include MediaWiki::Query::Lists
    include MediaWiki::Query::Properties

    protected

    # Gets the limited version of the integer, to ensure nobody provides an int
    # that is too large.
    # @param integer [Int] The number to limit.
    # @param max_user [Int] The maximum limit for normal users.
    # @param max_bot [Int] The maximum limit for bot users.
    # @since 0.8.0
    # @return [Int] The capped number.
    def get_limited(integer, max_user = 500, max_bot = 5000)
      return integer if integer < max_user
      if user_bot?
        integer > max_bot ? max_bot : integer
      else
        max_user
      end
    end
  end
end
