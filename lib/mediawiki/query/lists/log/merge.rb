module MediaWiki
  module Query
    module Lists
      module Log
        module Merge
          # Gets merge/merge logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, comment,
          # destination_title, mergepoint, timestamp.
          def get_merge_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('merge/merge', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << loghash_merge(log)
            end

            ret
          end
        end
      end
    end
  end
end
