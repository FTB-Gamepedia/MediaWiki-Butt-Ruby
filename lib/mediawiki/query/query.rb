require_relative 'meta/meta'
require_relative 'lists/lists'
require_relative 'properties/properties'

module MediaWiki
  module Query
    include MediaWiki::Query::Meta
    include MediaWiki::Query::Lists
    include MediaWiki::Query::Properties

    protected

    # Gets the limited version of the integer, to ensure nobody provides an int that is too large.
    # @param integer [Fixnum] The number to limit.
    # @param max_user [Fixnum] The maximum limit for normal users.
    # @param max_bot [Fixnum] The maximum limit for bot users.
    # @since 0.8.0
    # @return [Fixnum] The capped number.
    def get_limited(integer, max_user = 500, max_bot = 5000)
      return integer if integer <= max_user

      if user_bot?
        integer > max_bot ? max_bot : integer
      else
        max_user
      end
    end

    # Safely validates the given namespace ID, and returns 0 for the main namespace if invalid.
    # @param namespace [Fixnum] The namespace ID.
    # @return [Fixnum] Either the given namespace, if valid, or the main namespace ID 0 if invalid.
    def validate_namespace(namespace)
      MediaWiki::Constants::NAMESPACES.value?(namespace) ? namespace : 0
    end
  end
end
