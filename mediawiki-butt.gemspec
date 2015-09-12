Gem::Specification.new do |s|
  s.authors = ['Eli Foster']
  s.files = Dir['lib/*']
  s.name = 'mediawiki-butt'
  s.summary = "Interacting with the MediaWiki API"
  s.version = '0.1.0'
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
end
