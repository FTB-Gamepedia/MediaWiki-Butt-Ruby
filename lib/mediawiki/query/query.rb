require_relative 'meta/meta'
require_relative 'lists'
require_relative 'properties'

module MediaWiki
  module Query
    include MediaWiki::Query::Meta
    include MediaWiki::Query::Lists
    include MediaWiki::Query::Properties
  end
end
