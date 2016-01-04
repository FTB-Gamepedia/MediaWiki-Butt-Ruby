module MediaWiki
  class Tag
    # @return [String] The tag's name.
    attr_reader :name

    # @return [String] The tag's display name.
    attr_reader :display_name

    # @return [String] The descrtiption of the tag.
    attr_reader :description

    # @return [Int] The hitcount of the tag.
    attr_reader :hitcount

    # Creates a new Tag object representing a MediaWiki change tag.
    # @param opts [Hash] The hash containing all the valid data for the tag.
    # @option opts [String] :name The tag's name.
    # @option opts [String] :display The tag's display name.
    # @option opts [String] :desc The description of the tag.
    # @option opts [Int] :hits The hitcount for the tag.
    def initialize(opts = {})
      @name = opts[:name]
      @display_name = opts[:display]
      @description = opts[:desc]
      @hitcount = opts[:hits]
    end
  end
end
