module MediaWiki
  module Query
    module Lists
      module Log
        module Merge
          # Gets merge/merge logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, destination_title, mergepoint, timestamp.
          def get_merge_log(user = nil, title = nil, start = nil, stop = nil,
                             limit = 500)
            response = get_log('merge/merge', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                user: log['user'],
                comment: log['comment'],
                destination_title: log['params']['dest_title'],
                mergepoint: DateTime.strptime(log['params']['mergepoint'],
                                              MediaWiki::Constants::TIME_FORMAT),
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
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
