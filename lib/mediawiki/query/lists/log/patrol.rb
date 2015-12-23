module MediaWiki
  module Query
    module Lists
      module Log
        module Patrol
          # Gets patrol/patrol logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, current_revision, previous_revision,
          #   timestamp.
          def get_patrol_log(user = nil, title = nil, start = nil, stop = nil,
                             limit = 500)
            response = get_log('patrol/patrol', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                user: log['user'],
                comment: log['comment'],
                current_revision: log['patrol']['cur'],
                previous_revision: log['patrol']['prev'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }
              auto = log['patrol']['auto']
              hash[:automatic] = auto == 1

              ret << hash
            end

            ret
          end
        end
      end
    end
  end
end
