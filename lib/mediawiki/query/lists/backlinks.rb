module MediaWiki
  module Query
    module Lists
      module Backlinks
        # Gets an array of backlinks to a given title, like
        #   Special:WhatLinksHere.
        # @param title [String] The page to get the backlinks of.
        # @param limit [Int] The maximum number of pages to get. Defaults to query_limit_default attribute. Cannot be
        # greater than 500 for users or 5000 for bots.
        # @see https://www.mediawiki.org/wiki/API:Backlinks MediaWiki Backlinks
        #   API Docs
        # @since 0.1.0
        # @return [Array<String>] All backlinks until the limit
        def what_links_here(title, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'backlinks',
            bltitle: title,
            bllimit: get_limited(limit)
          }

          ret = []
          response = post(params)
          response['query']['backlinks'].each { |bl| ret << bl['title'] }

          ret
        end

        # Gets interwiki backlinks by the prefix and title.
        # @param prefix [String] The wiki prefix, e.g., "mcw".
        # @param title [String] The title of the page on that wiki.
        # @param limit [Int] See #what_links_here.
        # @see https://www.mediawiki.org/wiki/API:Iwbacklinks MediaWiki
        #   Iwbacklinks API Docs
        # @since 0.10.0
        # @return [Array<String>] All interwiki backlinking page titles.
        def get_interwiki_backlinks(prefix = nil, title = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'iwbacklinks',
            iwbllimit: get_limited(limit)
          }
          params[:iwblprefix] = prefix unless prefix.nil?
          params[:iwbltitle] = title unless title.nil?

          ret = []
          response = post(params)
          response['query']['iwbacklinks'].each { |bl| ret << bl['title'] }

          ret
        end

        # Gets language backlinks by the language and title.
        # @param language [String] The language code
        # @param title [String] The page title.
        # @param limit [Int] See {#what_links_here}
        # @see https://www.mediawiki.org/wiki/API:Langlinks MediaWiki Langlinks
        #   API Docs
        # @since 0.10.0
        # @return [Array<String>] All pages that link to the language links.
        def get_language_backlinks(language = nil, title = nil, limit = @query_limit_default)
          language.downcase! if language.match(/[^A-Z]*/)[0].size == 0
          params = {
            action: 'query',
            list: 'langbacklinks',
            lbltitle: get_limited(limit)
          }
          params[:lbllang] = language unless language.nil?
          params[:lbltitle] = title unless title.nil?

          ret = []
          response = post(params)
          response['query']['langbacklinks'].each { |bl| ret << bl['title'] }

          ret
        end

        # Gets image backlinks, or the pages that use a given image.
        # @param title [String] The image.
        # @param list_redirects [Nil/Boolean] Set to nil to list redirects and
        #   non-redirects. Set to true to only list redirects. Set to false to
        #   only list non-redirects.
        # @param thru_redirect [Boolean] Whether to list pages that link to a
        #   redirect of the image.
        # @param limit [Int] See {#what_links_here}
        # @see https://www.mediawiki.org/wiki/API:Imageusage MediaWiki
        #   Imageusage API Docs
        # @since 0.10.0
        # @return [Array<String>] All page titles that fit the requirements.
        def get_image_backlinks(title, list_redirects = nil, thru_redir = false, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'imageusage',
            iutitle: title,
            iulimit: get_limited(limit)
          }

          params[:iufilterredir] = list_redirects.nil? ? 'all' : list_redirects
          params[:iuredirect] = '1' if thru_redir

          response = post(params)
          ret = []
          response['query']['imageusage'].each { |bl| ret << bl['title'] }

          ret
        end

        # Gets all external link page titles.
        # @param url [String] The URL to get backlinks for.
        # @param limit [Int] See {#what_links_here}
        # @see https://www.mediawiki.org/wiki/API:Exturlusage MediaWiki
        #   Exturlusage API Docs
        # @since 0.10.0
        # @return [Array<String>] All pages that link to the given URL.
        # @return [Array<Hash>] All pages that link to any external links.
        def get_url_backlinks(url = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'exturlusage',
            eulimit: get_limited(limit)
          }
          params[:euquery] = url unless url.nil?

          response = post(params)
          ret = []
          response['query']['exturlusage'].each do |bl|
            if url.nil?
              hash = {
                url: bl['url'],
                title: bl['title']
              }
              ret << hash
            else
              ret << bl['title']
            end
          end

          ret
        end
      end
    end
  end
end
