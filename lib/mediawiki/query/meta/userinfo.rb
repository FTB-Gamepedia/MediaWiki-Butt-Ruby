module MediaWiki
  module Query
    module Meta
      # @see https://www.mediawiki.org/wiki/API:Userinfo MediaWiki Userinfo API Docs
      module UserInfo
        # Gets meta information for the currently logged in user.
        # @param prop [String] The uiprop to get. Optional.
        # @since 0.4.0
        # @return [Hash] Full, parsed response.
        # @return [Boolean] False if not logged in.
        def get_current_user_meta(prop = nil)
          return false unless @logged_in

          params = {
            action: 'query',
            meta: 'userinfo',
            uiprop: prop
          }

          post(params)
        end

        # Gets the current user's username.
        # @since 0.7.0
        # @return [String] Returns the username.
        # @return [Boolean] False if not currently logged in.
        def get_current_user_name
          return @name if @name
          name = get_current_user_meta
          name = name['query']['userinfo']['name'] if name

          name
        end

        # Returns whether or not the currently logged in user has any unread messages on their talk page.
        # @since 0.7.0
        # @return [Boolean] True if they have unreads, else false.
        def current_user_hasmsg?
          response = get_current_user_meta('hasmsg')
          return false unless response

          response['query']['userinfo']['messages'] == ''
        end

        # Gets a hash-of-arrays containing all the groups the user can add and remove people from.
        # @since 0.7.0
        # @return [Boolean] False if get_current_user_meta is false
        # @return [Hash<String, Array<String>>] All the groups that the user can :add, :remove, :addself, and
        #   :remove-self.
        def get_changeable_groups
          response = get_current_user_meta('changeablegroups')
          return false unless response

          changeablegroups = response['query']['userinfo']['changeablegroups']
          {
            :add => changeablegroups['add'],
            :remove => changeablegroups['remove'],
            :addself => changeablegroups['add-self'],
            :removeself => changeablegroups['add-self']
          }
        end

        # Gets the currently logged in user's real name.
        # @since 0.7.0
        # @return [String] The user's real name.
        # @return [Nil] If they don't have a real name set.
        def get_realname
          response = get_current_user_meta('realname')
          realname = response['query']['userinfo']['realname']
          return if realname == ''

          realname
        end

        # Gets the currently logged in user's email address.
        # @since 0.7.0
        # @return [String] The user's email address.
        # @return [Nil] If their email address is not set.
        def get_email_address
          response = get_current_user_meta('email')
          email = response['query']['userinfo']['email']
          return if email == ''

          email
        end

        # Gets the user's options.
        # @since 0.7.0
        # @return [Hash<String, Any>] The user's options.
        def get_current_user_options
          response = get_current_user_meta('options')
          ret = {}
          response['query']['userinfo']['options'].each { |k, v| ret[k] = v }
        end
      end
    end
  end
end
