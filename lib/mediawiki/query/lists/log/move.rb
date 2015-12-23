module MediaWiki
  module Query
    module Lists
      module Log
        module Move
          # Gets move logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_move_log(user = nil, title = nil, start = nil, stop = nil,
                           limit = 500)
            response = get_log('move/move', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                new_title: log['move']['new_title'],
                user: log['user'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              hash[:suppressedredirect] = log['move'].key?('suppressedredirect')

              ret << hash
            end

            ret
          end

          # Gets move logs for redirects.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_move_redirect_log(user = nil, title = nil, start = nil,
                                    stop = nil, limit = 500)
            resp = get_log('move/move_redir', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              if log.key?('actionhidden')
                hash[:hidden] = true
                hash[:title] = nil
                hash[:comment] = nil
                hash[:suppressedredirect] = log.key('suppressed')
              else
                hash[:title] = log['title']
                hash[:new_title] = log['move']['new_title']
                hash[:user] = log['user']
                hash[:comment] = log['comment']

                hash[:suppressedredirect] = log['move'].key?('suppressedredirect')
              end

              ret << hash
            end

            ret
          end
        end
      end
    end
  end
end
