module MediaWiki
  module Administration
    # Blocks the user.
    # @param user [String] The user to block.
    # @param expiry [String] The expiry timestamp using a relative expiry time.
    # @param reason [String] The reason to show in the block log.
    # @param nocreate [Boolean] Whether to allow them to create an account.
    # @return [String] The error code.
    # @return [Int] The block ID.
    def block(user, expiry = '2 weeks', reason = nil, nocreate = true)
      params = {
        action: 'block',
        user: user,
        expiry: expiry
      }

      token = get_token('block')
      params[:reason] = reason unless reason.nil?
      params[:nocreate] = '1' if nocreate == true
      params[:token] = token

      response = post(params)

      if !response['error'].nil?
        return response['error']['code']
      else
        return response['id'].to_i
      end
    end

    # Unblocks the user.
    # @param user [String] The user to unblock.
    # @param reason [String] The reason to show in the block log.
    # @return [String] The error code.
    # @return [Int] The block ID.
    def unblock(user, reason = nil)
      params = {
        action: 'unblock',
        user: user
      }
      token = get_token('unblock')
      params[:reason] = reason unless reason.nil?
      params[:token] = token

      response = post(params)

      if !response['error'].nil?
        return response['error']['code']
      else
        return response['id'].to_i
      end
    end
  end
end
