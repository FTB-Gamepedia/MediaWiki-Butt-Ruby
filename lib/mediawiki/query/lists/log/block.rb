require_relative '../../../constants'

module MediaWiki
  module Query
    module Lists
      module Log
        module Block
          # Gets block/block logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   blocked, flags, duration, expiry, blocker, comment, timestamp.
          def get_block_log(user = nil, title = nil, start = nil, stop = nil)
            response = get_log('block/block', user, title, start, stop)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_blockblock(log)
            end

            ret
          end

          # Gets block/reblock logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   blocked, flags, duration, expiry, blocker, comment, timestamp.
          def get_reblock_log(user = nil, title = nil, start = nil, stop = nil)
            response = get_log('block/reblock', user, title, start, stop)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_blockreblock(log)
            end

            ret
          end

          # Gets block/unblock logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   blocked, blocker, comment, timestamp.
          def get_unblock_log(user = nil, title = nil, start = nil, stop = nil)
            response = get_log('block/unblock', user, title, start, stop)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_blockunblock(log)
            end

            ret
          end
        end
      end
    end
  end
end
