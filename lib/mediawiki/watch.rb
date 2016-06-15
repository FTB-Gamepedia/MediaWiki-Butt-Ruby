module MediaWiki
  module Watch
    # Adds a page or an array of pages to the current user's watchlist.
    # @param titles [Array<String>, String] An array of page titles, or a page title as a string.
    # @return [Hash{String => Nil, Boolean}] Keys are page titles. Nil value means the page was missing, but it
    #   was watched anyway. True means the page was watched and it exists. False means the page was not watched.
    # @see https://www.mediawiki.org/wiki/API:Watch MediaWiki Watch API
    def watch(titles)
      watch_request(titles)
    end

    # Removes a page or an array of pages from the current user's watchlist.
    # @param (see #watch)
    # @return (see #watch)
    # @see https://www.mediawiki.org/wiki/API:Watch MediaWiki Watch API
    def unwatch(titles)
      watch_request(titles, true)
    end

    private

    # Submits a watch action request.
    # @param (see #watch)
    # @param unwatch [Boolean] Whether the request should unwatch the pages or not.
    # @return (see #watch)
    def watch_request(titles, unwatch = false)
      titles = titles.is_a?(Array) ? titles : [titles]
      params = {
        action: 'watch',
        titles: titles.shift(get_limited(titles.length, 50, 500)).join('|'),
        token: get_token('watch')
      }
      success_key = 'watched'
      if unwatch
        params[:unwatch] = 1
        success_key = 'unwatched'
      end
      params[:unwatch] = 1 if unwatch

      response = post(params)
      p response
      ret = {}
      response['watch'].each do |entry|
        p entry
        title = entry['title']
        if entry.key?(success_key)
          ret[title] = entry.key?('missing') ? nil : true
        else
          ret[title] = false
        end
      end
      ret
    end
  end
end
