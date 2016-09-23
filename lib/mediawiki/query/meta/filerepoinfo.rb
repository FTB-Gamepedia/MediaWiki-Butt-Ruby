module MediaWiki
  module Query
    module Meta
      # @see https://www.mediawiki.org/wiki/API:Filerepoinfo MediaWiki Filerepoinfo API Docs
      module FileRepoInfo
        # Gets FileRepoInfo for the property.
        # @param prop [String] The friprop to get.
        # @since 0.7.0
        # @return [Hash] The full parsed response.
        def get_filerepoinfo(prop)
          params = {
            action: 'query',
            meta: 'filerepoinfo',
            friprop: prop
          }

          post(params)
        end

        # Returns an array of all the wiki's file repository names.
        # @since 0.1.0
        # @return [Hash<String, String>] All wiki's file repository names. Keys are names, values are display names.
        def get_filerepo_names
          response = get_filerepoinfo('name|displayname')
          ret = {}
          response['query']['repos'].each { |h| ret[h['name']] = h['displayname'] }
          ret
        end

        # Gets the root URLs for the file repositories.
        # @since 0.7.0
        # @return [Hash<String, String>] A hash containing keys of the names, and values of the root URLs.
        def get_filerepo_rooturls
          response = get_filerepoinfo('name|rootUrl')
          ret = {}
          response['query']['repos'].each { |h| ret[h['name']] = h['rootUrl'] }
          ret
        end

        # Gets an array containing all local repositories.
        # @since 0.7.0
        # @return [Array<String>] All repository names that are marked as local.
        def get_local_filerepos
          get_filerepoinfo('name|local')['query']['repos'].select { |h| h.key?('local') }.collect { |h| h['name'] }
        end

        # Gets an array containing all repositories that aren't local.
        # @since 0.7.0
        # @return [Array<String>] All repositories that are not marked as local.
        def get_nonlocal_filerepos
          get_filerepoinfo('name|local')['query']['repos'].reject { |h| h.key?('local') }.collect { |h| h['name'] }
        end

        # Gets the repository names and their according URLs.
        # @since 0.7.0
        # @return [Hash<String, String>] Names as the keys, with their URLs as the values.
        def get_filerepo_urls
          response = get_filerepoinfo('name|url')
          ret = {}
          response['query']['repos'].each { |h| ret[h['name']] = h['url'] }
          ret
        end

        # Gets the repository names and their accoring thumbnail URLs.
        # @since 0.7.0
        # @return [Hash<String, String>] Names as the keys, with their URLs as the values.
        def get_filerepo_thumburls
          response = get_filerepoinfo('name|thumbUrl')
          ret = {}
          response['query']['repos'].each { |h| ret[h['name']] = h['thumbUrl'] }
          ret
        end

        # Gets the repository names and their according favicon URLs.
        # @since 0.7.0
        # @return [Hash<String, String>] Names as the keys, with their favicons as the values.
        def get_filerepo_favicons
          response = get_filerepoinfo('name|favicon')
          ret = {}
          response['query']['repos'].each { |h| ret[h['name']] = h['favicon'] }
          ret
        end
      end
    end
  end
end
