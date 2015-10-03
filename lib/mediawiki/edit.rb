module MediaWiki
  module Edit
    # Performs a standard edit. It cannot create pages. Please use create_page for that.
    # @param title [String] The page title.
    # @param text [String] The new content.
    # @param minor [Boolean] Will mark the edit as minor if true. Defaults to false.
    # @param bot [Boolean] Will mark the edit as bot edit if true. Defualts to true, for your convenience, bot developers.
    # @param summary [String] The edit summary. Optional.
    # @return [String] The new revision ID, or if it failed, the error code.
    def edit(title, text, minor = false, bot = true, *summary)
      params = {
        action: 'edit',
        title: title,
        text: text,
        nocreate: 1,
        format: 'json'
      }

      token = get_edit_token(title)

      params[:summary] = summary if defined? summary
      params[:minor] = '1' if minor
      params[:bot] = '1' if bot
      params[:token] = token

      response = post(params)

      if response["edit"]["result"] == "Success"
        response["edit"]["newrevid"]
      else
        response["error"]["code"]
      end
    end

    # Creates a new page.
    # @param title [String] The new page's title.
    # @param text [String] The new page's content.
    # @param summary [String] The edit summary. Defaults to "New page".
    # @param bot [Boolean] Will mark the edit as a bot edit if true. Defaults to true, for your convenience, bot developers.
    # @return [String] The new page ID, or if it failed, the error code.
    def create_page(title, text, summary = "New page", bot = true)
      params = {
        action: 'edit',
        title: title,
        summary: summary,
        text: text,
        createonly: 1,
        format: 'json'
      }

      token = get_edit_token(title)

      params[:bot] = '1' if bot
      params[:token] = token

      response = post(params)

      if response["edit"]["result"] == "Success"
        response["edit"]["pageid"]
      else
        response["error"]["code"]
      end
    end

    # Uploads a file from a URL.
    # @param url [String] The URL to the file.
    # @param filename [String] The preferred filename. This can include File: at the beginning, but it will be removed through regex. Optional. If ommitted, it will be everything after the last slash in the URL.
    # @return [Boolean/String] true if the upload was successful, else the warning key.
    def upload(url, *filename)
      params = {
        action: 'upload',
        url: url,
        format: 'json'
      }

      filename = defined? filename ? filename.sub(/$File:/, "") : url.split('/')[-1]

      token = get_edit_token(filename)

      params[:filename] = filename
      params[:token] = token

      response = post(params)
      if response["upload"]["result"] == "Success"
        true
      elsif response["upload"]["result"] == "Warning"
        warnings = response["upload"]["warnings"]
        warnings.keys[0]
      end
    end
  end
end
