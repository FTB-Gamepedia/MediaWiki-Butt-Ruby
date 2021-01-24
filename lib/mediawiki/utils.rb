module MediaWiki
  # Util class similar to MediaWiki's non-API util methods. This is not required automatically by
  # requiring 'mediawiki-butt' or 'mediawiki/butt'; you must require it explicitly.
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
