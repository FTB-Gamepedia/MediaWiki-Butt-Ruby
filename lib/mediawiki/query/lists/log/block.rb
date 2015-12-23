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
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   blocked, flags, duration, expiry, blocker, comment, timestamp.
          def get_block_log(user = nil, title = nil, start = nil, stop = nil,
                            limit = 500)
            response = get_log('block/block', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                blocked: log['title'],
                flags: log['block']['flags'],
                duration: log['block']['duration'],
                expiry: DateTime.strptime(log['block']['expiry'],
                                          MediaWiki::Constants::TIME_FORMAT),
                blocker: log['user'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              ret << hash
            end

            ret
          end

          # Gets block/reblock logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   blocked, flags, duration, expiry, blocker, comment, timestamp.
          def get_reblock_logs(user = nil, title = nil, start = nil, stop = nil,
                               limit = 500)
            response = get_log('block/reblock', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                blocked: log['title'],
                flags: log['block']['flags'],
                duration: log['block']['duration'],
                expiry: DateTime.strptime(log['block']['expiry'],
                                          MediaWiki::Constants::TIME_FORMAT),
                blocker: log['user'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              ret << hash
            end

            ret
          end

          # Gets block/unblock logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   blocked, blocker, comment, timestamp.
          def get_unblock_logs(user = nil, title = nil, start = nil, stop = nil,
                               limit = 500)
            response = get_log('block/unblock', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                blocked: log['title'],
                blocker: log['user'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT),
                comment: log['comment']
              }

              ret << hash
            end

            ret
          end
        end
      end
    end
  end
end
