require_relative 'butt/constants'

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

    # @return [Int] The size of the page in bytes.
    attr_reader :size

    # @return [String] A snippet of the text. This is typically given by searches.
    attr_reader :text_snippet

    # @return [Int] The number of words in the page.
    attr_reader :wordcount

    # @return [DateTime] The last time this page was edited.
    attr_reader :time

    # Creates a new instance of a page.
    # @param opts [Hash] The hash containing all possible data for the page.
    # @option opts [String] :title The page's title.
    # @option opts [String] :text The page's text.
    # @option opts [String] :id The page's ID.
    # @option opts [Int] :namespace The namespace that the page is in.
    # @option opts [Boolean] :redirect Whether the page is a redirect.
    # @option opts [Int] :size The size of the page in bytes.
    # @option opts [String] :snippet A snippet of the text.
    # @option opts [Int] :words The amount of words in the page.
    # @option opts [DateTime] :time The last time this page was edited.
    # @option opts [String] :time The last time this page was edited.
    def initialize(opts = {})
      @title = opts[:title]
      @text = opts[:text]
      @id = opts[:id]
      @namespace = opts[:namespace]
      @redirect = opts[:redirect]
      @size = opts[:size]
      @text_snippet = opts[:snippet]
      @wordcount = opts[:words]
      time = opts[:time]
      if time.is_a?(DateTime)
        @time = time
      else
        @time = DateTime.strptime(time, MediaWiki::Constants::TIME_FORMAT)
      end
    end
  end
end
