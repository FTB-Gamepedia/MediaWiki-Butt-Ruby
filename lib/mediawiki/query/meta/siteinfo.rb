module MediaWiki
  module Query
    module Meta
      # @see https://www.mediawiki.org/wiki/API:Siteinfo MediaWiki Siteinfo
      #   API Docs
      module SiteInfo
        # Gets wiki information. This method should rarely be used by
        #   normal users.
        # @param prop [String] The siprop parameter.
        # @since 0.6.0
        # @return [Response] Parsed full response.
        def get_siteinfo(prop)
          params = {
            action: 'query',
            meta: 'siteinfo',
            siprop: prop
          }

          post(params)
        end

        # Gets the statistics for the wiki.
        # @since 0.6.0
        # @return [Hash] The statistics and their according values.
        def get_statistics
          response = get_siteinfo('statistics')
          ret = {}
          response['query']['statistics'].each { |k, v| ret[k] = v }
          ret
        end

        # Gets the general information for the wiki.
        # @since 0.6.0
        # @return [Hash] The general info and their according values.
        def get_general
          response = get_siteinfo('general')
          ret = {}
          response['query']['general'].each { |k, v| ret[k] = v }
          ret
        end

        # Gets all extensions installed on the wiki.
        # @since 0.6.0
        # @return [Array] All extension names.
        def get_extensions
          response = get_siteinfo('extensions')
          ret = []
          response['query']['extensions'].each { |e| ret.push(e['name']) }
          ret
        end

        # Gets all languages and their codes.
        # @since 0.6.0
        # @return [Hash] All languages. Hash key value pair formatted as
        #   code => name.
        def get_languages
          response = get_siteinfo('languages')
          ret = {}
          response['query']['languages'].each { |l| ret[l['code']] = l['*'] }
          ret
        end

        # Gets all namespaces on the wiki and their IDs. Different from the
        #   Namespaces module.
        # @since 0.6.0
        # @return [Hash] All namespaces, formatted as ID => Name.
        def get_namespaces
          response = get_siteinfo('namespaces')
          ret = {}
          response['query']['namespaces'].each do |id, _|
            idid = response['query']['namespaces'][id]['id']
            name = response['query']['namespaces'][id]['*']
            ret[idid] = name
          end
          ret
        end

        # Gets all namespace aliases and their IDs.
        # @since 0.6.0
        # @return [Hash] All aliases, formatted as ID => Alias.
        def get_namespace_aliases
          response = get_siteinfo('namespacealiases')
          ret = {}
          response['query']['namespacealiases'].each do |i|
            ret[i['id']] = i['*']
          end
          ret
        end

        # Gets all special page aliases.
        # @since 0.6.0
        # @return [Hash] All aliases, formatted as RealName => Alias.
        def get_special_page_aliases
          response = get_siteinfo('specialpagealiases')
          ret = {}
          response['query']['specialpagealiases'].each do |i|
            ret[i['realname']] = i['aliases']
          end
          ret
        end

        # Gets all magic words and their aliases.
        # @since 0.6.0
        # @return [Hash] All magic words, formatted as Name => Alias.
        def get_magic_words
          response = get_siteinfo('magicwords')
          ret = {}
          response['query']['magicwords'].each do |w|
            ret[w['name']] = w['aliases']
          end
          ret
        end

        # Gets all user groups total.
        # @since 0.6.0
        # @return [Hash] All groups, formatted as Name => [Rights].
        def get_all_usergroups
          response = get_siteinfo('usergroups')
          ret = {}
          response['query']['usergroups'].each do |g|
            ret[g['name']] = g['rights']
          end
          ret
        end

        # Gets all file extensions that are allowed to be uploaded.
        # @since 0.6.0
        # @return [Array] All file extensions.
        def get_allowed_file_extensions
          response = get_siteinfo('fileextensions')
          ret = []
          response['query']['fileextensions'].each do |e|
            ret.push(e['ext'])
          end
          ret
        end

        # Gets the response for the restrictions siteinfo API. Not really for
        #   use by users, mostly for the other two restriction methods.
        # @since 0.6.0
        def get_restrictions_data
          response = get_siteinfo('restrictions')
          response['query']['restrictions']
        end

        # Gets all restriction/protection types.
        # @since 0.6.0
        # @return [Array] All protection types.
        def get_restriction_types
          restrictions = get_restrictions_data
          ret = []
          restrictions['types'].each { |t| ret.push(t) }
          ret
        end

        # Gets all restriction/protection levels.
        # @since 0.6.0
        # @return [Array] All protection levels.
        def get_restriction_levels
          restrictions = get_restrictions_data
          ret = []
          restrictions['levels'].each { |l| ret.push(l) }
          ret
        end

        # Gets all skins and their codes.
        # @since 0.6.0
        # @return [Hash] All skins, formatted as Code => Name
        def get_skins
          response = get_siteinfo('skins')
          ret = {}
          response['query']['skins'].each do |s|
            ret[s['code']] = s['*']
          end
          ret
        end

        # Gets all HTML tags added by installed extensions.
        # @since 0.6.0
        # @return [Array] All extension tags.
        def get_extension_tags
          response = get_siteinfo('extensiontags')
          ret = []
          response['query']['extensiontags'].each do |t|
            ret.push(t)
          end
          ret
        end

        # Gets all function hooks.
        # @since 0.6.0
        # @return [Array] All function hooks.
        def get_function_hooks
          response = get_siteinfo('functionhooks')
          ret = []
          response['query']['functionhooks'].each do |h|
            ret.push(h)
          end
          ret
        end

        # Gets all variables that are usable on the wiki, such as NUMBEROFPAGES.
        # @since 0.6.0
        # @return [Array] All variable string values.
        def get_variables
          response = get_siteinfo('variables')
          ret = []
          response['query']['variables'].each do |v|
            ret.push(v)
          end
          ret
        end
      end
    end
  end
end
