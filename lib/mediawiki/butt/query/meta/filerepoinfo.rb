module MediaWiki
  module Query
    module Meta
      # @see https://www.mediawiki.org/wiki/API:Filerepoinfo MediaWiki
      #   Filerepoinfo API Docs
      module FileRepoInfo
        # Gets FileRepoInfo for the property.
        # @param prop [String] The friprop to get.
        # @since 0.7.0
        # @return [Response] The full parsed response.
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
        # @return [Array] All wiki's file repository names.
        def get_filerepo_names
          response = get_filerepoinfo('name|displayname')
          ret = {}
          response['query']['repos'].each { |n, dn| ret[n] = dn }
          ret
        end

        # Gets the root URLs for the file repositories.
        # @since 0.7.0
        # @return [Hash] A hash containing keys of the names, and values of the
        #   root URLs.
        def get_filerepo_rooturls
          response = get_filerepoinfo('name|rootUrl')
          ret = {}
          response['query']['repos'].each { |n, r| ret[n] = r }
          ret
        end

        # Gets an array containing all local repositories.
        # @since 0.7.0
        # @return [Array] All repositories that are marked as local.
        def get_local_filerepos
          response = get_filerepoinfo('name|local')
          ret = []
          response['query']['repos'].each do |n, l|
            ret.push(n) if l == 'true'
          end

          ret
        end

        # Gets an array containing all repositories that aren't local.
        # @since 0.7.0
        # @return [Array] All repositories that are not marked as local.
        def get_nonlocal_filerepos
          response = get_filerepoinfo('name|local')
          ret = []
          response['query']['repos'].each do |n, l|
            ret.push(n) if l == 'false'
          end

          ret
        end

        # Gets the repository names and their according URLs.
        # @since 0.7.0
        # @return [Hash] Names as the keys, with their URLs as the values.
        def get_filerepo_urls
          response = get_filerepoinfo('name|url')
          ret = {}
          response['query']['repos'].each { |n, u| ret[n] = u }
          ret
        end

        # Gets the repository names and their accoring thumbnail URLs.
        # @since 0.7.0
        # @return [Hash] Names as the keys, with their URLs as the values.
        def get_filerepo_thumburls
          response = get_filerepoinfo('name|thumbUrl')
          ret = {}
          response['query']['repos'].each { |n, u| ret[n] = u }
          ret
        end

        # Gets the repository names and their according favicon URLs.
        # @since 0.7.0
        # @return [Hash] Names as the keys, with their favicons as the values.
        def get_filerepo_favicons
          response = get_filerepoinfo('name|favicon')
          ret = {}
          response['query']['repos'].each { |n, f| ret[n] = f }
          ret
        end
      end
    end
  end
end
