require_relative '../../constants'
require_relative '../query'
require_relative 'backlinks'
require_relative 'categories'
require_relative 'all'
require_relative 'search'
require_relative 'miscellaneous'
require_relative 'log/log'

module MediaWiki
  module Query
    module Lists
      include MediaWiki::Query::Lists::Backlinks
      include MediaWiki::Query::Lists::Categories
      include MediaWiki::Query::Lists::All
      include MediaWiki::Query::Lists::Search
      include MediaWiki::Query::Lists::Miscellaneous
      include MediaWiki::Query::Lists::Log
    end
  end
end
