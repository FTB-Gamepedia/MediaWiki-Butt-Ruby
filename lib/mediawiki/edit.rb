module MediaWiki
  module Edit
    # Performs a standard edit.
    #   It cannot create pages. Please use create_page for that.
    # @param title [String] The page title.
    # @param text [String] The new content.
    # @param minor [Boolean] Will mark the edit as minor if true.
    #   Defaults to false.
    # @param bot [Boolean] Will mark the edit as bot edit if true.
    #   Defualts to true, for your convenience, bot developers.
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

      token = get_token('edit', title)

      params[:summary] = summary if defined? summary
      params[:minor] = '1' if minor
      params[:bot] = '1' if bot
      params[:token] = token

      response = post(params)

      if response['edit']['result'] == 'Success'
        return response['edit']['newrevid']
      else
        return response['error']['code']
      end
    end

    # Creates a new page.
    # @param title [String] The new page's title.
    # @param text [String] The new page's content.
    # @param summary [String] The edit summary. Defaults to 'New page'.
    # @param bot [Boolean] Will mark the edit as a bot edit if true.
    #   Defaults to true, for your convenience, bot developers.
    # @return [String] The new page ID, or if it failed, the error code.
    def create_page(title, text, summary = 'New page', bot = true)
      params = {
        action: 'edit',
        title: title,
        summary: summary,
        text: text,
        createonly: 1,
        format: 'json'
      }

      token = get_token('edit', title)

      params[:bot] = '1' if bot
      params[:token] = token

      response = post(params)

      if response['edit']['result'] == 'Success'
        return response['edit']['pageid']
      else
        return response['error']['code']
      end
    end

    # Uploads a file from a URL.
    # @param url [String] The URL to the file.
    # @param filename [String] The preferred filename.
    #   This can include File: at the beginning, but it will be removed
    #   through regex. Optional. If ommitted, it will be everything after
    #   the last slash in the URL.
    # @return [Boolean/String] true if the upload was successful, else the
    #   warning's key. Returns false if the file extension is not valid.
    def upload(url, filename = nil)
      params = {
        action: 'upload',
        url: url,
        format: 'json'
      }

      if filename.nil?
        filename = url.split('/')[-1]
      else
        filename = filename.sub(/^File:/, '')
      end

      ext = filename.split('.')[-1]
      allowed_extensions = get_allowed_file_extensions
      if allowed_extensions.include? ext

        token = get_token('edit', filename)
        params[:filename] = filename
        params[:token] = token

        response = post(params)
        if response['upload']['result'] == 'Success'
          return true
        elsif response['upload']['result'] == 'Warning'
          return response['upload']['warnings'].keys[0]
        end
      else
        return false
      end
    end

    # Performs a move on a page.
    # @param from [String] The page to be moved.
    # @param to [String] The destination of the move.
    # @param reason [String] The reason for the move, which shows up in the log.
    #   Optionl.
    # @param talk [Boolean] Whether to move the associated talk page.
    #   Defaults to true.
    # @param redirect [Boolean] Whether to create a redirect. Defaults to false.
    # @return [Boolean/String] true if successful, the error code if not.
    def move(from, to, reason = nil, talk = true, redirect = false)
      params = {
        action: 'move',
        from: from,
        to: to
      }

      token = get_token('move', from)
      params[:reason] = reason unless reason.nil?
      params[:movetalk] = '1' if talk == true
      params[:noredirect] = '1' if redirect == false
      params[:token] = token

      response = post(params)
      if !response['move'].nil?
        return true
      else
        return response['error']['code']
      end
    end

    # Deletes a page.
    # @param title [String] The page to delete.
    # @param reason [String] The reason to be displayed in logs. Optional.
    # @return [Boolean/String] true if successful, the error code if not.
    def delete(title, reason = nil)
      params = {
        action: 'delete',
        title: title
      }

      token = get_token('delete', title)
      params[:reason] = reason unless reason.nil?
      params[:token] = token

      response = post(params)
      if !response['delete'].nil?
        return true
      else
        return response['error']['code']
      end
    end
  end
end
