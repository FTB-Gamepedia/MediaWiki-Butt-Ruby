require_relative 'auth'

module MediaWiki
  class Butt
    include MediaWiki::Auth
    # Creates a new instance of MediaWiki::Butt
    #
    # ==== Attributes
    #
    # * +url+ - The FULL wiki URL. api.php can be omitted, but it will make harsh assumptions about your wiki configuration.
    # * +use_ssl+ - Whether or not to use SSL. Will default to true.
    #
    # ==== Examples
    #
    # The example below shows an ideal usage of the method.
    # => butt = MediaWiki::Butt.new("http://ftb.gamepedia.com/api.php")
    #
    # The example below shows a less than idea, but still functional, usage of the method. It is less than ideal because it has to assume that your API page is at /api.php, but it could easily be at /w/api.php, or even /wiki/api.php. It also does not use a secure connection.
    # => butt = MediaWiki::Butt.new("http://ftb.gamepedia.com", false)
    def initialize(url, use_ssl = true)
      if url =~ /api.php$/
        @url = url
      else
        @url = "#{url}/api.php"
      end

      @ssl = use_ssl
      @logged_in = false
      @tokens = {}
    end
  end
end
