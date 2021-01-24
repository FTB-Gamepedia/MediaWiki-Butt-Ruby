module MediaWiki
  # Util class similar to MediaWiki's non-API JavaScript util methods.
  #
  # To use this class it must be explicitly required. Including `mediawiki/butt` does not automatically include this class.
  #
  # Its methods are class methods, not instance methods. They are not executed on your {MediaWiki::Butt} instance.
  #
  # @example
  #   require 'mediawiki/utils'
  #   encoded_url = MediaWiki::Utils.encode_url(url)
  class Utils
    # Encodes the URL like mw.util.rawurlencode JS.
    # @param str [String] The string to replace (typically a page title).
    # @return [String] The encoded string.
    def self.encode_url(str)
      str.gsub!(/!/, '%21')
      str.gsub!(/'/, '%27')
      str.gsub!(/\(/, '%28')
      str.gsub!(/\)/, '%29')
      str.gsub!(/\*/, '%2A')
      str.gsub!(/~/, '%7E')

      str
    end
  end
end
