require_relative 'translate/translate'
require_relative 'abuse_filter'
require_relative 'tilesheets'

module MediaWiki
  module Extension
    include MediaWiki::Extension::Translate
    include MediaWiki::Extension::AbuseFilter
    include MediaWiki::Extension::Tilesheets
  end
end
