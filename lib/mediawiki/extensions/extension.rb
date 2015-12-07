require_relative 'translate/translate'
require_relative 'abuse_filter'

module MediaWiki
  module Extension
    include MediaWiki::Extension::Translate
    include MediaWiki::Extension::AbuseFilter
  end
end
