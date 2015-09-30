module MediaWiki
  module Edit
    # Performs a standard edit. It cannot create pages. Please use create_page for that.
    # @param title [String] The page title.
    # @param text [String] The new content.
    # @param summary [String] The edit summary. Optional.
    # @param minor [Boolean] Will mark the edit as minor if true. Defaults to false.
    # @param bot [Boolean] Will mark the edit as bot edit if true. Defualts to true, for your convenience, bot developers.
    # @return [String] The new revision ID, or if it failed, the error code.
    def edit(title, text, summary = nil, minor = false, bot = true)
      params = {
        action: 'edit',
        title: title,
        summary: summary,
        text: text,
        nocreate: 1,
        format: 'json'
      }

      token = get_edit_token(title)
      puts token

      params[:minor] = '1' if minor == true
      params[:bot] = '1' if bot == true
      params[:token] = token

      response = post(params)

      if response["error"]["code"].nil?
        return response["edit"]["newrevid"]
      else
        return response["error"]["code"]
      end
    end
  end
end
