require_relative 'meta/meta'
require_relative 'lists/lists'
require_relative 'properties/properties'

module MediaWiki
  module Query
    include MediaWiki::Query::Meta
    include MediaWiki::Query::Lists
    include MediaWiki::Query::Properties
  end
end
