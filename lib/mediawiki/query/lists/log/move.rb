module MediaWiki
  module Query
    module Lists
      module Log
        module Move
          # Gets move/move logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_move_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('move/move', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_move(log)
            end

            ret
          end

          # Gets move/move_redir logs for redirects.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_move_redirect_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('move/move_redir', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_move(log)
            end

            ret
          end
        end
      end
    end
  end
end
