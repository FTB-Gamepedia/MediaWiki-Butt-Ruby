require_relative 'users'

module MediaWiki
  module Query
    module Lists
      module QueryPage
        include MediaWiki::Query::Lists::Users

        # @since 0.10.0
        # @see #get_querypage
        def get_mostrevisions_page
          get_querypage('Mostrevisions')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostlinked_page
          get_querypage('Mostlinked')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostlinkedtemplates_page
          get_querypage('Mostlinkedtemplates')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostlinkedcategories_page
          get_querypage('Mostlinkedcategories')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostinterwikis_page
          get_querypage('Mostinterwikis')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostimages_page
          get_querypage('Mostimages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_mostcategories_page
          get_querypage('Mostcategories')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_listduplicatedfiles_page
          get_querypage('ListDuplicatedFiles')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_listredirects_page
          get_querypage('Listredirects')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedtemplates_page
          get_querypage('Wantedtemplates')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedpages_page
          get_querypage('Wantedpages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedfiles_page
          get_querypage('Wantedfiles')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_wantedcategories_page
          get_querypage('Wantedcategories')
        end

        # @since 0.10.0
        # @see #get_querypage
        # @return [Nil] If the user does not have the necessary rights.
        def get_unwatchedpages_page
          rights = get_userrights
          if rights != false && rights.include?('unwatchedpages')
            get_querypage('Unwatchedpages')
          else
            return nil
          end
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_unusedtemplates_page
          get_querypage('Unusedtemplates')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_unusedcategories_page
          get_querypage('Unusedcategories')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_uncategorizedtemplates_page
          get_querypage('Uncategorizedtemplates')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_uncategorizedpages_page
          get_querypage('Uncategorizedpages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_uncategorizedcategories_page
          get_querypage('Uncategorizedcategories')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_shortpages_page
          get_querypage('Shortpages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_withoutinterwiki_page
          get_querypage('Withoutinterwiki')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_fewestrevisions_page
          get_querypage('Fewestrevisions')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_lonelypages_page
          get_querypage('Lonelypages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_ancientpages_page
          get_querypage('Ancientpages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_longpages_page
          get_querypage('Longpages')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_doubleredirects_page
          get_querypage('DoubleRedirects')
        end

        # @since 0.10.0
        # @see #get_querypage
        def get_brokenredirects_page
          get_querypage('BrokenRedirects')
        end

        # Performs a QueryPage request.
        # @param page [String] The special page (not including Special:) to
        #   query.
        # @see https://www.mediawiki.org/wiki/API:Querypage MediaWiki QueryPage
        #   API Docs
        # @since 0.10.0
        # @return [Hash] The response.
        def get_querypage(page)
          params = {
            action: 'query',
            list: 'querypage',
            qppage: page,
            qplimit: get_limited(@query_limit)
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
