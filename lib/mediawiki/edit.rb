module MediaWiki
  module Edit
    # Performs a standard non-creation edit.
    # @param title [String] The page title.
    # @param text [String] The new content.
    # @param minor [Boolean] Will mark the edit as minor if true.
    # @param bot [Boolean] Will mark the edit as bot edit if true. Defaults to true, for your convenience, bot
    #   developers.
    # @param summary [String] The edit summary. Optional.
    # @see https://www.mediawiki.org/wiki/API:Changing_wiki_content Changing wiki content on the MediaWiki API
    #   documentation
    # @see https://www.mediawiki.org/wiki/API:Edit MediaWiki Edit API Docs
    # @since 0.2.0
    # @raise [EditError] if the edit failed somehow
    # @return [String] The new revision ID
    # @return [Boolean] False if there was no change in the edit.
    def edit(title, text, minor = false, bot = true, summary = nil)
      params = {
        action: 'edit',
        title: title,
        text: text,
        nocreate: 1,
        format: 'json'
      }

      token = get_token('edit', title)

      params[:summary] = summary unless summary.nil?
      params[:minor] = '1' if minor
      params[:bot] = '1' if bot
      params[:token] = token

      response = post(params)

      if response.dig('edit', 'result') == 'Success'
        return false if response.dig('edit', 'nochange')
        return response.dig('edit', 'newrevid')
      end

      raise EditError.new(response.dig('error', 'code') || 'Unknown error code')
    end

    # Creates a new page.
    # @param title [String] The new page's title.
    # @param text [String] The new page's content.
    # @param summary [String] The edit summary.
    # @param bot [Boolean] Will mark the edit as a bot edit if true. Defaults to true, for your convenience, bot
    #   developers.
    # @see https://www.mediawiki.org/wiki/API:Changing_wiki_content Changing wiki content on the MediaWiki API
    #   documentation
    # @see https://www.mediawiki.org/wiki/API:Edit MediaWiki Edit API Docs
    # @since 0.3.0
    # @raise [EditError] If there was some error when creating the page.
    # @return [String] The new page ID
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

      return response['edit']['pageid'] if response.dig('edit', 'result') == 'Success'
      raise EditError.new(response.dig('error', 'code') || 'Unknown error code')
    end

    # Uploads a file from a URL.
    # @param url [String] The URL to the file.
    # @param filename [String] The preferred filename. This can include File: at the beginning, but it will be
    #   removed through regex. Optional. If omitted, it will be everything after the last slash in the URL.
    # @return [Boolean] True if the upload was successful, false if the file extension is not valid.
    # @see https://www.mediawiki.org/wiki/API:Changing_wiki_content Changing wiki content on the MediaWiki API
    #   documentation
    # @see https://www.mediawiki.org/wiki/API:Upload MediaWiki Upload API Docs
    # @since 0.3.0
    # @return [Boolean] Whether the upload was successful. It is likely that if it returns false, it also raised a
    #   warning.
    def upload(url, filename = nil)
      params = {
        action: 'upload',
        url: url,
        format: 'json'
      }

      filename = filename.nil? ? url.split('/')[-1] : filename.sub(/^File:/, '')

      ext = filename.split('.')[-1]
      allowed_extensions = get_allowed_file_extensions
      return false unless allowed_extensions.include?(ext)

      token = get_token('edit', filename)
      params[:filename] = filename
      params[:token] = token

      response = post(params)

      response.dig('upload', 'warnings')&.each do |warning|
        warn warning
      end

      response.dig('upload', 'result') == 'Success'
    end

    # Performs a move on a page.
    # @param from [String] The page to be moved.
    # @param to [String] The destination of the move.
    # @param reason [String] The reason for the move, which shows up in the log. Optional.
    # @param talk [Boolean] Whether to move the associated talk page.
    # @param redirect [Boolean] Whether to create a redirect.
    # @see https://www.mediawiki.org/wiki/API:Changing_wiki_content Changing wiki content on the MediaWiki API
    #   documentation
    # @see https://www.mediawiki.org/wiki/API:Move MediaWiki Move API Docs
    # @since 0.5.0
    # @raise [EditError]
    # @return [Boolean] True if it was successful.
    def move(from, to, reason = nil, talk = true, redirect = false)
      params = {
        action: 'move',
        from: from,
        to: to
      }

      token = get_token('move', from)
      params[:reason] = reason unless reason.nil?
      params[:movetalk] = '1' if talk
      params[:noredirect] = '1' if redirect
      params[:token] = token

      response = post(params)

      return true if response['move']
      raise EditError.new(response.dig('error', 'code') || 'Unknown error code')
    end

    # Deletes a page.
    # @param title [String] The page to delete.
    # @param reason [String] The reason to be displayed in logs. Optional.
    # @see https://www.mediawiki.org/wiki/API:Changing_wiki_content Changing wiki content on the MediaWiki API
    #   documentation
    # @see https://www.mediawiki.org/wiki/API:Delete MediaWiki Delete API Docs
    # @since 0.5.0
    # @raise [EditError]
    # @return [Boolean] True if successful.
    def delete(title, reason = nil)
      params = {
        action: 'delete',
        title: title
      }

      token = get_token('delete', title)
      params[:reason] = reason unless reason.nil?
      params[:token] = token

      response = post(params)
      return true if response['delete']
      raise EditError.new(response.dig('error', 'code') || 'Unknown error code')
    end
  end
end
