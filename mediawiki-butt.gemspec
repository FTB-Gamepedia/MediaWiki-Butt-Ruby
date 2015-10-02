Gem::Specification.new do |s|
  s.authors = ['Eli Foster', 'Eric Schneider (xbony2)']
  s.name = 'mediawiki-butt'
  s.summary = "Interacting with the MediaWiki API"
  s.version = '0.3.1'
  s.license = 'CC-BY-NC-ND-4.0'
  # Expand on this description eventually.
  s.description = <<-EOF
    MediaWiki::Butt is a Ruby Gem that provides a fully-featured MediaWiki API interface.
  EOF
  s.email = 'elifosterwy@gmail.com'
  s.homepage = 'https://github.com/ftb-gamepedia/mediawiki-butt-ruby'
  s.metadata = {
    'issue_tracker' => 'https://github.com/ftb-gamepedia/mediawiki-butt-ruby/issues'
  }
  s.post_install_message = 'ONE OF US! ONE OF US!'
  s.required_ruby_version = '>= 2.0'
  s.files = [
    "lib/mediawiki-butt.rb",
    "lib/mediawiki/butt.rb",
    "lib/mediawiki/auth.rb",
    "lib/mediawiki/exceptions.rb",
    "lib/mediawiki/query.rb",
    "lib/mediawiki/constants.rb",
    "lib/mediawiki/edit.rb",
    "CHANGELOG.md"
  ]

  # TODO: Figure out what version we should require for JSON and HTTPClient
  s.add_runtime_dependency("string-utility", ">= 2.0.0")
  s.add_runtime_dependency("httpclient")
end
