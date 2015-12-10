module MediaWiki
  module Query
    module Meta
      # @see https://www.mediawiki.org/wiki/API:Userinfo MediaWiki Userinfo
      #   API Docs
      module UserInfo
        # Gets meta information for the currently logged in user.
        # @param prop [String] The uiprop to get. Optional.
        # @since 0.4.0
        # @return [Response/Boolean] Either a full, parsed response.
        # @return [Boolean] False if not logged in.
        def get_current_user_meta(prop = nil)
          if @logged_in
            params = {
              action: 'query',
              meta: 'userinfo',
              uiprop: prop
            }

            post(params)
          else
            return false
          end
        end

        # Gets the current user's username.
        # @since 0.7.0
        # @return [String] Returns the username.
        # @return [Boolean] False if...
        def get_current_user_name
          if !@name.nil?
            return @name
          else
            name = get_current_user_meta
            name = name['query']['userinfo']['name'] if name != false

            name
          end
        end

        # Returns whether or not the currently logged in user has any unread
        #   messages on their talk page.
        # @since 0.7.0
        # @return [Boolean] True if they have unreads, else false.
        def current_user_hasmsg?
          response = get_current_user_meta('hasmsg')
          if response != false
            if !response['query']['userinfo']['messages'] == ''
              return false
            else
              return true
            end
          else
            return false
          end
        end

        # Gets a hash-of-arrays containing all the groups the user can add and
        #   remove people from.
        # @since 0.7.0
        # @return [Boolean] False if get_current_user_meta is false
        # @return [Hash] All the groups that the user can add, remove, add-self,
        #   and remove-self.
        def get_changeable_groups
          response = get_current_user_meta('changeablegroups')
          if response != false
            ret = {}
            add = []
            remove = []
            addself = []
            removeself = []
            changeablegroups = response['query']['userinfo']['changeablegroups']
            changeablegroups['add'].each { |g| add.push(g) }
            changeablegroups['remove'].each { |g| remove.push(g) }
            changeablegroups['add-self'].each { |g| addself.push(g) }
            changeablegroups['remove-self'].each { |g| removeself.push(g) }
            ret['add'] = add
            ret['remove'] = remove
            ret['addself'] = addself
            ret['removeself'] = removeself
            return ret
          else
            return false
          end
        end

        # Gets the currently logged in user's real name.
        # @since 0.7.0
        # @return [String] The user's real name.
        # @return [Nil] If they don't have a real name set.
        def get_realname
          response = get_current_user_meta('realname')
          if response['query']['userinfo']['realname'] == ''
            return nil
          else
            return response['query']['userinfo']['realname']
          end
        end

        # Gets the currently logged in user's email address.
        # @since 0.7.0
        # @return [String] The user's email address.
        # @return [Nil] If their email address is not set.
        def get_email_address
          response = get_current_user_meta('email')
          if response['query']['userinfo']['email'] == ''
            return nil
          else
            return response['query']['userinfo']['email']
          end
        end

        # Gets the user's options.
        # @since 0.7.0
        # @return [Hash] The user's options.
        def get_current_user_options
          response = get_current_user_meta('options')
          ret = {}
          response['query']['userinfo']['options'].each { |k, v| ret[k] = v }
        end
      end
    end
  end
end
