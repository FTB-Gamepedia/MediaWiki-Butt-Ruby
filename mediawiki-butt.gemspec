Gem::Specification.new do |s|
  s.authors = ['Eli Foster', 'Eric Schneider (xbony2)']
  s.name = 'mediawiki-butt'
  s.summary = 'Interacting with the MediaWiki API'
  s.version = '0.8.1'
  s.license = 'CC-BY-NC-ND-4.0'
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
  s.post_install_message = 'ONE OF US! ONE OF US!'
  s.required_ruby_version = '>= 2.1'
  s.files = [
    'lib/mediawiki-butt.rb',

    'lib/mediawiki/administration.rb',
    'lib/mediawiki/auth.rb',
    'lib/mediawiki/butt.rb',
    'lib/mediawiki/constants.rb',
    'lib/mediawiki/edit.rb',
    'lib/mediawiki/exceptions.rb',

    'lib/mediawiki/query/lists.rb',
    'lib/mediawiki/query/query.rb',

    'lib/mediawiki/query/meta/filerepoinfo.rb',
    'lib/mediawiki/query/meta/meta.rb',
    'lib/mediawiki/query/meta/siteinfo.rb',
    'lib/mediawiki/query/meta/userinfo.rb',

    'lib/mediawiki/query/properties/contributors.rb',
    'lib/mediawiki/query/properties/files.rb',
    'lib/mediawiki/query/properties/pages.rb',
    'lib/mediawiki/query/properties/properties.rb'
  ]

  s.add_runtime_dependency('httpclient', '>= 2.6.0.1')
end
