module MediaWiki
  module Query
    module Lists
      module Log
        module Import
          # Gets import/interwiki logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, comment, timestamp,
          #   count, interwiki_title.
          def get_interwiki_import_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('import/interwiki', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_importinterwiki(log)
            end

            ret
          end

          # Gets import/upload logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id, title, user, timestamp, comment.
          def get_upload_import_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('import/upload', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_importupload(log)
            end

            ret
          end
        end
      end
    end
  end
end
