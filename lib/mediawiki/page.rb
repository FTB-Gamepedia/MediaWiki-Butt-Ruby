module MediaWiki
  class Page
    # @return [String] The page's title.
    attr_reader :title

    # @return [String] The page's text.
    attr_reader :text

    # @return [String] The page's ID.
    attr_reader :id

    # @return [Int] The namespace ID.
    # @see MediaWiki::Constants::NAMESPACES
    attr_reader :namespace

    # @return [Boolean] Whether the page is a redirect.
    attr_reader :redirect

    # Creates a new instance of a page.
    # @param opts [Hash] The hash containing all possible data for the page.
    # @option opts [String] :title The page's title.
    # @option opts [String] :text The page's text.
    # @option opts [String] :id The page's ID.
    # @option opts [Int] :namespace The namespace that the page is in.
    # @option opts [Boolean] :redirect Whether the page is a redirect.
    def initialize(opts = {})
      @title = opts[:title]
      @text = opts[:text]
      @id = opts[:id]
      @namespace = opts[:namespace]
      @redirect = opts[:redirect]
    end
  end
end
