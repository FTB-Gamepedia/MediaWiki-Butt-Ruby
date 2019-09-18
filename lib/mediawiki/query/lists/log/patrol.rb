module MediaWiki
  module Query
    module Lists
      module Log
        module Patrol
          # Gets patrol/patrol logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, comment,
          #   current_revision, previous_revision, timestamp.
          def get_patrol_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('patrol/patrol', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << loghash_patrol(log)
            end

            ret
          end
        end
      end
    end
  end
end
