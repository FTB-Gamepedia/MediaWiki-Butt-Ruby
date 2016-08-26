require_relative '../query'

module MediaWiki
  module Query
    module Properties
      module Pages
        # Gets all categories in the page.
        # @param title [String] The page title.
        # @see https://www.mediawiki.org/wiki/API:Property/Categories MediaWiki Categories Property API Docs
        # @since 0.8.0
        # @return [Array<String>] All the categories
        # @return [Nil] If the title does not exist.
        def get_categories_in_page(title)
          params = {
            prop: 'categories',
            titles: title
          }

          query(params) do |return_val, query|
            pageid = nil
            query['pages'].each do |r, _|
              pageid = r
              break
            end

            return if query['pages'][pageid].key?('missing')
            query['pages'][pageid].fetch('categories', []).each { |c| return_val << c['title'] }
          end
        end

        # Gets the wiki text for the given page. Returns nil if it for some reason cannot get the text, for example,
        # if the page does not exist.
        # @param (see #get_categories_in_page)
        # @see https://www.mediawiki.org/wiki/API:Revisions MediaWiki Revisions API Docs
        # @since 0.8.0
        # @return [String] String containing page contents.
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

          revision = response['query']['pages'][revid]

          revision['missing'] == '' ? nil : revision['revisions'][0]['*']
        end

        # Gets the revision ID for the given page.
        # @param (see #get_categories_in_page)
        # @see (see #get_text)
        # @since 0.8.0
        # @return [Fixnum] The page's ID
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
            return revid == '-1' ? nil : revid.to_i
          end
        end

        # Gets all the external links on a given page.
        # @param (see #get_categories_in_page)
        # @param limit [Fixnum] The maximum number of members to get. Defaults to 500, and cannot be greater than
        #   that unless the user is a bot. If the user is a bot, the limit cannot be greater than 5000.
        # @see https://www.mediawiki.org/wiki/API:Extlinks MediaWiki Extlinks API Docs
        # @since 0.8.0
        # @return [Array<String>] All external link URLs.
        def get_external_links(title, limit = @query_limit_default)
          params = {
            action: 'query',
            titles: title,
            prop: 'extlinks',
            ellimit: get_limited(limit)
          }

          query(params) do |return_val, query|
            query['pages'].each do |revid, _|
              return if revid == '-1'
              query['pages'][revid]['extlinks'].each { |l| return_val << l['*'] }
            end
          end
        end

        # Gets whether the current user watches the page.
        # @param (see #get_categories_in_page)
        # @see https://www.mediawiki.org/wiki/API:Info MediaWiki Info API Docs
        # @since 0.8.0
        # @return [Boolean] Whether the user watches the page.
        # @return [Boolean] False if the user is not logged in.
        # @return [Nil] If the page does not exist.
        def do_i_watch?(title)
          return false unless @logged_in
          params = {
            action: 'query',
            titles: title,
            prop: 'info',
            inprop: 'watched'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid].key?('watched')
          end
        end

        # Gets whether the current user (can be anonymous) can read the page.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Boolean] Whether the user can read the page.
        # @return [Nil] If the page does not exist.
        def can_i_read?(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info',
            inprop: 'readable'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid].key?('readable')
          end
        end

        # Gets whether the given page is a redirect.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Boolean] Whether the page is a redirect.
        # @return [Nil] If the page does not exist.
        def page_redirect?(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid].key?('redirect')
          end
        end

        # Gets whether the given page only has one edit.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Boolean] Whether the page only has one edit.
        # @return [Nil] If the page does not exist.
        def page_new?(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid].key?('new')
          end
        end

        # Gets the number of users that watch the given page.
        # @param (see #get_categoeries_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Fixnum] The number of watchers.
        # @return [Nil] If the page does not exist.
        def get_number_of_watchers(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info',
            inprop: 'watchers'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid]['watchers']
          end
        end

        # Gets the way the title is actually displayed, after any in-page changes to its display, e.g., using a
        # template to make the first letter lowercase, in cases like iPhone.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [String] The page's display title.
        # @return [Nil] If the page does not exist.
        def get_display_title(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info',
            inprop: 'displaytitle'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid]['displaytitle']
          end
        end

        # Gets the levels of protection on the page.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Array<Hash<Symbol, String>>] Hashes of all the protection levels. Each has includes a 'type', a
        #   'level', and an 'expiry'. Type refers to the type of change protected against, like 'edit'. Level refers to
        #   the usergroup that is needed to perform that type of edit, like 'sysop'. Expiry refers to when the
        #   protection will expire, if never, it will be 'infinity.
        # @return [Nil] If the page does not exist.
        def get_protection_levels(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info',
            inprop: 'protection'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return if revid == '-1'
            protection = response['query']['pages'][revid]['protection']
            protection.each do |p|
              p.keys.each { |k| p[k.to_sym] = p.delete(k) }
            end
            return protection
          end
        end

        # Gets the size, in bytes, of the page.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Fixnum] The number of bytes.
        # @return [Nil] If the page does not exist.
        def get_page_size(title)
          params = {
            action: 'query',
            titles: title,
            prop: 'info'
          }

          response = post(params)
          response['query']['pages'].each do |revid, _|
            return revid == '-1' ? nil : response['query']['pages'][revid]['length']
          end
        end

        # Gets all of the images in the given page.
        # @param (see #get_external_links)
        # @see https://www.mediawiki.org/wiki/API:Images MediaWiki Images API Docs
        # @since 0.8.0
        # @return [Array<String>] All of the image titles in the page.
        # @return [Nil] If the page does not exist.
        def get_images_in_page(title, limit = @query_limit_default)
          params = {
            prop: 'images',
            titles: title,
            imlimit: get_limited(limit)
          }

          query(params) do |return_val, query|
            query['pages'].each do |revid, _|
              return if revid == '-1'
              query['pages'][revid]['images'].each { |img| return_val << img['title'] }
            end
          end
        end

        # Gets all of the templates in the given page.
        # @param (see #get_external_links)
        # @see https://www.mediawiki.org/wiki/API:Templates MediaWiki Templates API Docs
        # @since 0.8.0
        # @return [Array<String>] All of the template titles in the page.
        # @return [Nil] If the page does not exist.
        def get_templates_in_page(title, limit = @query_limit_default)
          params = {
            prop: 'templates',
            titles: title,
            tllimit: get_limited(limit)
          }

          query(params) do |return_val, query|
            query['pages'].each do |revid, _|
              return if revid == '-1'
              query['pages'][revid]['templates'].each { |template| return_val << template['title'] }
            end
          end
        end

        # Gets all of the interwiki links on the given page.
        # @param (see #get_external_links)
        # @see https://www.mediawiki.org/wiki/API:Iwlinks MediaWiki Interwiki Links API Docs
        # @since 0.8.0
        # @return [Array<Hash<Symbol, String>>] All interwiki links. Each hash has a :prefix and :title
        # @return [Nil] If the page does not exist.
        def get_interwiki_links_in_page(title, limit = @query_limit_default)
          params = {
            prop: 'iwlinks',
            titles: title,
            tllimit: get_limited(limit)
          }

          query(params) do |return_val, query|
            query['pages'].each do |revid, _|
              return if revid == '-1'
              query['pages'][revid].fetch('iwlinks', []).each do |l|
                return_val << { prefix: l['prefix'], title: l['*'] }
              end
            end
          end
        end

        # Gets a hash of data for the page in every language that it is available in. This includes url, language
        # name, autonym, and its title. This method does not work with the Translate extension.
        # @param (see #get_external_links)
        # @see https://www.mediawiki.org/wiki/API:Langlinks MediaWiki Langlinks API Docs
        # @since 0.8.0
        # @return [Hash] The data described previously.
        # @return [Nil] If the page does not exist.
        def get_other_langs_of_page(title, limit = @query_limit_default)
          params = {
            prop: 'langlinks',
            titles: title,
            lllimit: get_limited(limit),
            llprop: 'url|langname|autonym'
          }

          query(params) do |return_val, query|
            query['pages'].each do |revid, _|
              return if revid == '-1'
              query['pages'][revid]['langlinks'].each do |l|
                return_val[l['lang'].to_sym] = {
                  url: l['url'],
                  langname: l['langname'],
                  autonym: l['autonym'],
                  title: l['*']
                }
              end
            end
          end
        end

        # Gets every single link in a page.
        # @param (see #get_external_links)
        # @see https://www.mediawiki.org/wiki/API:Links MediaWiki Links API Docs
        # @since 0.8.0
        # @return [Array<String>] All link titles.
        # @return [Nil] If the page does not exist.
        def get_all_links_in_page(title, limit = @query_limit_default)
          params = {
            prop: 'links',
            titles: title,
            pllimit: get_limited(limit)
          }

          query(params) do |return_val, query|
            query['pages'].each do |revid, _|
              return if revid == '-1'
              query['pages'][revid]['links'].each { |l| return_val << l['title'] }
            end
          end
        end
      end
    end
  end
end
