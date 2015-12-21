module MediaWiki
  module Query
    module Lists
      module Backlinks
        # Gets an array of backlinks to a given title, like
        #   Special:WhatLinksHere.
        # @param title [String] The page to get the backlinks of.
        # @param limit [Int] The maximum number of pages to get. Defaults to
        #   500, and cannot be greater than that unless the user is a bot. If
        #   the user is a bot, the limit cannot be greater than 5000.
        # @see https://www.mediawiki.org/wiki/API:Backlinks MediaWiki Backlinks
        #   API Docs
        # @since 0.1.0
        # @return [Array<String>] All backlinks until the limit
        def what_links_here(title, limit = 500)
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
        def get_interwiki_backlinks(prefix = nil, title = nil, limit = 500)
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
        def get_language_backlinks(language = nil, title = nil, limit = 500)
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
      end
    end
  end
end
