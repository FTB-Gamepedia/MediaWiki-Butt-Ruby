require_relative '../query'

module MediaWiki
  module Query
    module Properties
      module Pages
        # Gets all categories in the page.
        # @param title [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Property/Categories
        #   MediaWiki Categories Property API Docs
        # @since 0.8.0
        # @return [Array] All the categories
        # @return [Nil] If the title does not exist.
        def get_categories_in_page(title)
          params = {
            action: 'query',
            prop: 'categories',
            titles: title
          }

          response = post(params)
          pageid = nil
          ret = []
          response['query']['pages'].each { |r, _| pageid = r }
          if response['query']['pages'][pageid]['missing'] == ''
            return nil
          else
            response['query']['pages'][pageid]['categories'].each do |c|
              ret.push(c['title'])
            end
          end

          ret
        end

        # Gets the wiki text for the given page. Returns nil if it for some
        #   reason cannot get the text, for example, if the page does not exist.
        # @param title [String] The page title
        # @see https://www.mediawiki.org/wiki/API:Revisions MediaWiki Revisions
        #   API Docs
        # @since 0.8.0
        # @return [String/nil] String containing page contents.
        # @return [Nil] If the page does not exist.
        def get_text(title)
          params = {
            action: 'query',
            prop: 'revisions',
            rvprop: 'content',
            titles: title
          }

          response = post(params)
          revid = nil
          response['query']['pages'].each { |r, _| revid = r }

          if response['query']['pages'][revid]['missing'] == ''
            return nil
          else
            return response['query']['pages'][revid]['revisions'][0]['*']
          end
        end

        # Gets the revision ID for the given page.
        # @param title [String] The page title
        # @see https://www.mediawiki.org/wiki/API:Revisions MediaWiki Revisions
        #   API Docs
        # @since 0.8.0
        # @return [Int/nil] The page's ID
        # @return [Nil] If the page does not exist.
        def get_id(title)
          params = {
            action: 'query',
            prop: 'revisions',
            rvprop: 'content',
            titles: title
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return revid.to_i
            else
              return nil
            end
          end
        end

        # Gets all the external links on a given page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Extlinks MediaWiki Extlinks
        #   API Docs
        # @since 0.8.0
        # @return [Array] All external link URLs.
        def get_external_links(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'extlinks',
            ellimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              response['query']['pages'][revid]['extlinks'].each do |l|
                ret.push(l['*'])
              end
            else
              return nil
            end
          end

          ret
        end

        # Gets whether the current user watches the page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Boolean] Whether the user watches the page.
        # @return [Boolean] False if the user is not logged in.
        # @return [Nil] If the page does not exist.
        def do_i_watch?(page)
          if @logged_in
            params = {
              action: 'query',
              titles: page,
              prop: 'info',
              inprop: 'watched'
            }

            response = post(params)
            response['query']['pages'].each do |revid, _|
              if revid != '-1'
                return response['query']['pages'][revid].key?('watched')
              else
                return nil
              end
            end
          else
            return false
          end
        end

        # Gets whether the current user (can be anonymous) can read the page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Boolean] Whether the user can read the page.
        # @return [Nil] If the page does not exist.
        def can_i_read?(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info',
            inprop: 'readable'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return response['query']['pages'][revid].key?('readable')
            else
              return nil
            end
          end
        end

        # Gets whether the given page is a redirect.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Boolean] Whether the page is a redirect.
        # @return [Nil] If the page does not exist.
        def page_redirect?(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return response['query']['pages'][revid].key?('redirect')
            else
              return nil
            end
          end
        end

        # Gets whether the given page only has one edit.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Boolean] Whether the page only has one edit.
        # @return [Nil] If the page does not exist.
        def page_new?(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return response['query']['pages'][revid].key?('new')
            else
              return nil
            end
          end
        end

        # Gets the number of users that watch the given page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Fixnum] The number of watchers.
        # @return [Nil] If the page does not exist.
        def get_number_of_watchers(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info',
            inprop: 'watchers'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return response['query']['pages'][revid]['watchers']
            else
              return nil
            end
          end
        end

        # Gets the way the title is actually displayed, after any in-page
        #   changes to its display, e.g., using a template to make the first
        #   letter lowercase, in cases like iPhone.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [String] The page's display title.
        # @return [Nil] If the page does not exist.
        def get_display_title(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info',
            inprop: 'displaytitle'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return response['query']['pages'][revid]['displaytitle']
            else
              return nil
            end
          end
        end

        # Gets the levels of protection on the page.
        # @param page [String] The page title.
        # @return [Array] Hashes of all the protection levels. Each has includes
        #   a 'type', a 'level', and an 'expiry'. Type refers to the type of
        #   change protected against, like 'edit'. Level refers to the usergroup
        #   that is needed to perform that type of edit, like 'sysop'. Expiry
        #   refers to when the protection will expire, if never, it will be
        #   'infinity'.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Nil] If the page does not exist.
        def get_protection_levels(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info',
            inprop: 'protection'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              protection = response['query']['pages'][revid]['protection']
              protection.each do |p|
                p.keys.each { |k| p[k.to_sym] = p.delete(k) }
              end
              return protection
            else
              return nil
            end
          end
        end

        # Gets the size, in bytes, of the page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Fixnum] The number of bytes.
        # @return [Nil] If the page does not exist.
        def get_page_size(page)
          params = {
            action: 'query',
            titles: page,
            prop: 'info'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              return response['query']['pages'][revid]['length']
            else
              return nil
            end
          end
        end

        # Gets all of the images in the given page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Images MediaWiki Images API
        #   Docs
        # @since 0.8.0
        # @return [Array] All of the image titles in the page.
        # @return [Nil] If the page does not exist.
        def get_images_in_page(page)
          params = {
            action: 'query',
            prop: 'images',
            titles: page,
            imlimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              response['query']['pages'][revid]['images'].each do |img|
                ret.push(img['title'])
              end
            else
              return nil
            end
          end

          ret
        end

        # Gets all of the templates in the given page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Templates MediaWiki Templates
        #   API Docs
        # @since 0.8.0
        # @return [Array] All of the templte titles in the page.
        # @return [Nil] If the page does not exist.
        def get_templates_in_page(page)
          params = {
            action: 'query',
            prop: 'templates',
            titles: page,
            tllimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              response['query']['pages'][revid]['templates'].each do |tmp|
                ret.push(tmp['title'])
              end
            else
              return nil
            end
          end

          ret
        end

        # Gets all of the interwiki links on the given page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Iwlinks MediaWiki Interwiki
        #   Links API Docs
        # @since 0.8.0
        # @return [Array] All interwiki link titles.
        # @return [Nil] If the page does not exist.
        def get_interwiki_links_in_page(page)
          params = {
            action: 'query',
            prop: 'iwlinks',
            titles: page,
            tllimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              response['query']['pages'][revid]['iwlinks'].each do |l|
                ret.push(l['*'])
              end
            else
              return nil
            end
          end

          ret
        end

        # Gets a hash of data for the page in every language that it is
        #   available in. This includes url, language name, autonym, and its
        #   title. This method does not work with the Translate extension.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Langlinks MediaWiki Langlinks
        #   API Docs
        # @since 0.8.0
        # @return [Hash] The data described previously.
        # @return [Nil] If the page does not exist.
        def get_other_langs_of_page(page)
          params = {
            action: 'query',
            prop: 'langlinks',
            titles: page,
            lllimit: get_limited(@query_limit),
            llprop: 'url|langname|autonym'
          }

          response = post(params)
          ret = {}
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              response['query']['pages'][revid]['langlinks'].each do |l|
                ret[l['lang'].to_sym] = {
                  url: l['url'],
                  langname: l['langname'],
                  autonym: l['autonym'],
                  title: l['*']
                }
              end
            else
              return nil
            end
          end

          ret
        end

        # Gets every single link in a page.
        # @param page [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Links MediaWiki Links API Docs
        # @since 0.8.0
        # @return [Array] All link titles.
        # @return [Nil] If the page does not exist.
        def get_all_links_in_page(page)
          params = {
            action: 'query',
            prop: 'links',
            titles: page,
            pllimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |revid, _|
            if revid != '-1'
              response['query']['pages'][revid]['links'].each do |l|
                ret.push(l['title'])
              end
            else
              return nil
            end
          end

          ret
        end
      end
    end
  end
end
