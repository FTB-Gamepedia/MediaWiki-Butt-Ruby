require_relative 'contributors'
require_relative 'pages'
require_relative 'files'

module MediaWiki
  module Query
    module Properties
      include MediaWiki::Query::Properties::Contributors
      include MediaWiki::Query::Properties::Pages
      include MediaWiki::Query::Properties::Files
    end
  end
end
