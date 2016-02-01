module MediaWiki
  # Util class similar to MediaWiki's non-API util methods. This is not required automatically by
  # requiring 'mediawiki-butt' or 'mediawiki/butt'; you must require it explicitly.
  class Utils
    # Encodes the URL like mw.util.rawurlencode JS.
    # @todo Perhaps write a StringUtility method for better gsubs?
    # @param str [String] The string to replace (typically a page title).
    # @return [String] The encoded string.
    def self.encode_url(str)
      str.gsub!(/!/,'%21') || str
      str.gsub!(/'/,'%27') || str
      str.gsub!(/\(/,'%28') || str
      str.gsub!(/\)/,'%29') || str
      str.gsub!(/\*/,'%2A') || str
      str.gsub!(/~/,'%7E') || str
      return str
    end
  end
end
