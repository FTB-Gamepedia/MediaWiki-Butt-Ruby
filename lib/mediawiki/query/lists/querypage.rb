require_relative 'users'

module MediaWiki
  module Query
    module Lists
      module QueryPage
        include MediaWiki::Query::Lists::Users

        # @since 0.10.0
        # @see #get_querypage
        def get_mostrevisions_page(limit = @query_limit_default)
          get_querypage('Mostrevisions', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostlinked_page(limit = @query_limit_default)
          get_querypage('Mostlinked', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostlinkedtemplates_page(limit = @query_limit_default)
          get_querypage('Mostlinkedtemplates', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostlinkedcategories_page(limit = @query_limit_default)
          get_querypage('Mostlinkedcategories', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostinterwikis_page(limit = @query_limit_default)
          get_querypage('Mostinterwikis', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostimages_page(limit = @query_limit_default)
          get_querypage('Mostimages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostcategories_page(limit = @query_limit_default)
          get_querypage('Mostcategories', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_listduplicatedfiles_page(limit = @query_limit_default)
          get_querypage('ListDuplicatedFiles', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_listredirects_page(limit = @query_limit_default)
          get_querypage('Listredirects', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedtemplates_page(limit = @query_limit_default)
          get_querypage('Wantedtemplates', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedpages_page(limit = @query_limit_default)
          get_querypage('Wantedpages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedfiles_page(limit = @query_limit_default)
          get_querypage('Wantedfiles', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedcategories_page(limit = @query_limit_default)
          get_querypage('Wantedcategories', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        # @return [Nil] If the user does not have the necessary rights.
        def get_unwatchedpages_page(limit = @query_limit_default)
          rights = get_userrights
          if rights != false && rights.include?('unwatchedpages')
            get_querypage('Unwatchedpages', limit)
          else
            return nil
          end
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_unusedtemplates_page(limit = @query_limit_default)
          get_querypage('Unusedtemplates', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_unusedcategories_page(limit = @query_limit_default)
          get_querypage('Unusedcategories', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_uncategorizedtemplates_page(limit = @query_limit_default)
          get_querypage('Uncategorizedtemplates', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_uncategorizedpages_page(limit = @query_limit_default)
          get_querypage('Uncategorizedpages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_uncategorizedcategories_page(limit = @query_limit_default)
          get_querypage('Uncategorizedcategories', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_shortpages_page(limit = @query_limit_default)
          get_querypage('Shortpages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_withoutinterwiki_page(limit = @query_limit_default)
          get_querypage('Withoutinterwiki', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_fewestrevisions_page(limit = @query_limit_default)
          get_querypage('Fewestrevisions', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_lonelypages_page(limit = @query_limit_default)
          get_querypage('Lonelypages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_ancientpages_page(limit = @query_limit_default)
          get_querypage('Ancientpages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_longpages_page(limit = @query_limit_default)
          get_querypage('Longpages', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_doubleredirects_page(limit = @query_limit_default)
          get_querypage('DoubleRedirects', limit)
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_brokenredirects_page(limit = @query_limit_default)
          get_querypage('BrokenRedirects', limit)
        end

        # Performs a QueryPage request.
        # @param page [String] The special page (not including Special:) to
        #   query.
        # @param limit [Int] The limit.
        # @see https://www.mediawiki.org/wiki/API:Querypage MediaWiki QueryPage
        #   API Docs
        # @since 0.10.0
        # @return [Hash] The response.
        def get_querypage(page, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'querypage',
            qppage: page,
            qplimit: get_limited(limit)
          }
          response = post(params)
          ret = []
          response['query']['querypage']['results'].each do |result|
            ret << result['title']
          end

          ret
        end
      end
    end
  end
end
