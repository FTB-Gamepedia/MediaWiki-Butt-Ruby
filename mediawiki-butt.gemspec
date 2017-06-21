Gem::Specification.new do |s|
  s.authors = ['Eli Foster', 'Eric Schneider (xbony2)']
  s.name = 'mediawiki-butt'
  s.summary = 'Interacting with the MediaWiki API'
  s.version = '2.0.0'
  s.license = 'MIT'
  # Expand on this description eventually.
  s.description = <<-EOF
    MediaWiki::Butt provides a fully-featured interface to the MediaWiki API. \
    It includes methods for changing wiki content, authentication, \
    and queries.

  EOF
  s.email = 'elifosterwy@gmail.com'
  s.homepage = 'https://github.com/ftb-gamepedia/mediawiki-butt-ruby'
  s.metadata = {
    'issue_tracker' => 'https://github.com/ftb-gamepedia/mediawiki-butt-ruby/issues'
  }
  s.required_ruby_version = '>= 2.3'
  s.files = [
    'lib/mediawiki-butt.rb',

    'lib/mediawiki/administration.rb',
    'lib/mediawiki/auth.rb',
    'lib/mediawiki/butt.rb',
    'lib/mediawiki/constants.rb',
    'lib/mediawiki/edit.rb',
    'lib/mediawiki/exceptions.rb',
    'lib/mediawiki/utils.rb',
    'lib/mediawiki/watch.rb',
    'lib/mediawiki/purge.rb',

    'lib/mediawiki/query/query.rb',

    'lib/mediawiki/query/meta/filerepoinfo.rb',
    'lib/mediawiki/query/meta/meta.rb',
    'lib/mediawiki/query/meta/siteinfo.rb',
    'lib/mediawiki/query/meta/userinfo.rb',

    'lib/mediawiki/query/properties/contributors.rb',
    'lib/mediawiki/query/properties/files.rb',
    'lib/mediawiki/query/properties/pages.rb',
    'lib/mediawiki/query/properties/properties.rb',

    'lib/mediawiki/query/lists/all.rb',
    'lib/mediawiki/query/lists/backlinks.rb',
    'lib/mediawiki/query/lists/categories.rb',
    'lib/mediawiki/query/lists/lists.rb',
    'lib/mediawiki/query/lists/miscellaneous.rb',
    'lib/mediawiki/query/lists/querypage.rb',
    'lib/mediawiki/query/lists/recent_changes.rb',
    'lib/mediawiki/query/lists/search.rb',
    'lib/mediawiki/query/lists/users.rb',

    'lib/mediawiki/query/lists/log/block.rb',
    'lib/mediawiki/query/lists/log/delete.rb',
    'lib/mediawiki/query/lists/log/import.rb',
    'lib/mediawiki/query/lists/log/log.rb',
    'lib/mediawiki/query/lists/log/merge.rb',
    'lib/mediawiki/query/lists/log/move.rb',
    'lib/mediawiki/query/lists/log/newusers.rb',
    'lib/mediawiki/query/lists/log/patrol.rb',
    'lib/mediawiki/query/lists/log/rights.rb',
    'lib/mediawiki/query/lists/log/upload.rb',
    'lib/mediawiki/query/lists/log/protect.rb',

    'CHANGELOG.md',
    'LICENSE.md'
  ]

  s.add_runtime_dependency('httpclient', '~> 2.8')
end
