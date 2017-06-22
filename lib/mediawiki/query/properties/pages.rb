require_relative '../query'
require_relative '../../constants'

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
            pageid = query['pages'].keys.find(MediaWiki::Constants::MISSING_PAGEID_PROC) { |id| id != '-1' }
            return if query['pages'][pageid].key?('missing')
            return_val.concat(query['pages'][pageid].fetch('categories', []).collect { |c| c['title'] })
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
          revid = response['query']['pages'].keys.find(MediaWiki::Constants::MISSING_PAGEID_PROC) { |id| id != '-1' }
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

          post(params)['query']['pages'].keys.find { |id| id != '-1' }&.to_i
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
            pageid = query['pages'].keys.find { |id| id != '-1' }
            return unless pageid
            return_val.concat(query['pages'][pageid]['extlinks'].collect { |l| l['*'] })
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
          page_info_contains_key(title, 'watched', 'watched')
        end

        # Gets whether the current user (can be anonymous) can read the page.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Boolean] Whether the user can read the page.
        # @return [Nil] If the page does not exist.
        def can_i_read?(title)
          page_info_contains_key(title, 'readable', 'readable')
        end

        # Gets whether the given page is a redirect.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Boolean] Whether the page is a redirect.
        # @return [Nil] If the page does not exist.
        def page_redirect?(title)
          page_info_contains_key(title, 'redirect')
        end

        # Gets whether the given page only has one edit.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Boolean] Whether the page only has one edit.
        # @return [Nil] If the page does not exist.
        def page_new?(title)
          page_info_contains_key(title, 'new')
        end

        # Gets the number of users that watch the given page.
        # @param (see #get_categoeries_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Fixnum] The number of watchers.
        # @return [Nil] If the page does not exist.
        def get_number_of_watchers(title)
          page_info_get_val(title, 'watchers', 'watchers')
        end

        # Gets the way the title is actually displayed, after any in-page changes to its display, e.g., using a
        # template to make the first letter lowercase, in cases like iPhone.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [String] The page's display title.
        # @return [Nil] If the page does not exist.
        def get_display_title(title)
          page_info_get_val(title, 'displaytitle', 'displaytitle')
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

          pageid = response['query']['pages'].keys.find { |id| id != '-1' }
          return unless pageid
          protection = response['query']['pages'][pageid]['protection']
          protection.each do |p|
            p.keys.each { |k| p[k.to_sym] = p.delete(k) }
          end

          protection
        end

        # Gets the size, in bytes, of the page.
        # @param (see #get_categories_in_page)
        # @see (see #do_i_watch?)
        # @since 0.8.0
        # @return [Fixnum] The number of bytes.
        # @return [Nil] If the page does not exist.
        def get_page_size(title)
          page_info_get_val(title, 'length')
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
            pageid = query['pages'].keys.find { |id| id != '-1' }
            return unless pageid
            return_val.concat(query['pages'][pageid]['images'].collect { |img| img['title'] })
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
            pageid = query['pages'].keys.find { |id| id != '-1' }
            return unless pageid
            templates = query['pages'][pageid].fetch('templates', [])
            return_val.concat(templates.collect { |template| template['title'] })
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
            pageid = query['pages'].keys.find { |id| id != '-1' }
            return unless pageid
            iwlinks = query['pages'][pageid].fetch('iwlinks', [])
            return_val.concat(iwlinks.collect { |l| { prefix: l['prefix'], title: l['*']} })
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
            pageid = query['pages'].keys.find { |id| id != '-1' }
            return unless pageid
            query['pages'][pageid]['langlinks'].each do |l|
              return_val[l['lang'].to_sym] = {
                url: l['url'],
                langname: l['langname'],
                autonym: l['autonym'],
                title: l['*']
              }
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
            pageid = query['pages'].keys.find { |id| id != '-1' }
            return unless pageid
            return_val.concat(query['pages'][pageid]['links'].collect { |l| l['title'] })
          end
        end

        private

        # Performs a query for the page info with the provided property.
        # @param title [String] The page name
        # @param inprop [String] The inprop to use. See the MediaWiki API documentation.
        # @return (see #post)
        def get_basic_page_info(title, inprop = nil)
          params = {
            action: 'query',
            titles: title,
            prop: 'info'
          }
          params[:inprop] = inprop if inprop

          post(params)
        end

        # Performs a query for the page info with the provided property. Checks if the first non-missing page returned
        #   contains the provided key.
        # @param title [String] The page name
        # @param key [String] The key to check for
        # @param inprop [String] The inprop to use. See the MediaWiki API documentation.
        # @return [Nil] If the page is not found.
        # @return [Boolean] If the page object contains the provided key.
        def page_info_contains_key(title, key, inprop = nil)
          response = get_basic_page_info(title, inprop)
          pageid = response['query']['pages'].keys.find { |id| id != '-1' }
          return unless pageid
          response['query']['pages'][pageid].key?(key)
        end

        # Performs a query for the page info with the provided property, and returns a value by the provided key in
        #   the page's returned object.
        # @param (see #page_info_contains_key)
        # @return [Nil] If the page is not found.
        # @return [Any] The returned value for the key.
        def page_info_get_val(title, key, inprop = nil)
          response = get_basic_page_info(title, inprop)
          pageid = response['query']['pages'].keys.find { |id| id != '-1' }
          return unless pageid
          response['query']['pages'][pageid][key]
        end
      end
    end
  end
end
