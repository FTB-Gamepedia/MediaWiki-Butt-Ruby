require_relative 'siteinfo'
require_relative 'filerepoinfo'
require_relative 'userinfo'

module MediaWiki
  module Query
    module Meta
      include MediaWiki::Query::Meta::UserInfo
      include MediaWiki::Query::Meta::FileRepoInfo
      include MediaWiki::Query::Meta::UserInfo
    end
  end
end
