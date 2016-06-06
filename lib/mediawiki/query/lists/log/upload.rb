module MediaWiki
  module Query
    module Lists
      module Log
        # @todo upload/revert
        module Upload
          # Gets upload/overwrite logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash<Symbol, Any>>] The events, containing the following keys: id, title, user, sha,
          #   comment, timestamp.
          def get_upload_overwrite_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('upload/overwrite', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_upload(log)
            end

            ret
          end

          # Gets upload/upload logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash<Symbol, Any>>] The events, containing the following keys: id, title, user, sha,
          #   comment, timestamp.
          def get_upload_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('upload/upload', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_upload(log)
            end

            ret
          end
        end
      end
    end
  end
end
