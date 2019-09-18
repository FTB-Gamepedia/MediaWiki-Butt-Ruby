module MediaWiki
  module Query
    module Lists
      module Log
        module Protect
          # Gets protect/modify logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, description, user, comment,
          #   timestamp, details.
          def get_modify_protection_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('protect/modify', user, title, start, stop,
                               limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << loghash_protect(log)
            end

            ret
          end

          # Gets protect/move_prot logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, old_title, user, comment,
          #   timestamp.
          def get_move_protected_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('protect/move_prot', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << loghash_protectmoveprot(log)
            end

            ret
          end

          # Gets protect/protect logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, description, user, comment,
          #   timestamp, details.
          def get_protect_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('protect/protect', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << loghash_protect(log)
            end

            ret
          end

          # Gets protect/unprotect logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, comment, timestamp.
          def get_unprotect_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('protect/unprotect', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << loghash_protectunprotect(log)
            end

            ret
          end
        end
      end
    end
  end
end
