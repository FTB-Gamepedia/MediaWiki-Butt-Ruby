module MediaWiki
  module Query
    module Lists
      module Log
        # @todo delete/event
        # @todo delete/revision
        module Delete
          # Gets delete/delete logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, comment, timestamp.
          def get_delete_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('delete/delete', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_general(log)
            end

            ret
          end

          # Gets delete/restore logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, comment, timestamp.
          def get_deletion_restore_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('delete/restore', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_general(log)
            end

            ret
          end
        end
      end
    end
  end
end
