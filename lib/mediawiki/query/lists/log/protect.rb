module MediaWiki
  module Query
    module Lists
      module Log
        module Protect
          # Gets protect/modify logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, description, user, comment, timestamp, details.
          def get_modify_protection_log(user = nil, title = nil, start = nil,
                                        stop = nil, limit = 500)
            response = get_log('protect/modify', user, title, start, stop,
                               limit)

            ret = []
            time_format = MediaWiki::Constants::TIME_FORMAT
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                description: log['params']['description'],
                user: log['user'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'], time_format)
              }

              hash[:details] = []

              log['params']['detail'].each do |detail|
                details_hash = {
                  type: detail['type'],
                  level: detail['level']
                }
                expire = detail['expiry']
                if expire != 'infinite'
                  details_hash[:expiry] = DateTime.strptime(expire, time_format)
                end
                hash[:details] << detail_hash
              end

              ret << hash
            end

            ret
          end

          # Gets protect/move_prot logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, old_title, user, comment, timestamp.
          def get_move_protected_log(user = nil, title = nil, start = nil,
                                     stop = nil, limit = 500)
            resp = get_log('protect/move_prot', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                old_title: log['params']['oldtitle_title'],
                user: log['user'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              ret << hash
            end

            ret
          end

          # Gets protect/protect logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, description, user, comment, timestamp, details.
          def get_protect_log(user = nil, title = nil, start = nil, stop = nil,
                              limit = 500)
            response = get_log('protect/protect', user, title, start, stop,
                               limit)

            ret = []
            time_format = MediaWiki::Constants::TIME_FORMAT
            response['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                description: log['params']['description'],
                user: log['user'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'], time_format)
              }

              hash[:details] = []

              log['params']['detail'].each do |detail|
                details_hash = {
                  type: detail['type'],
                  level: detail['level']
                }
                expire = detail['expiry']
                if expire != 'infinite'
                  details_hash[:expiry] = DateTime.strptime(expire, time_format)
                end
                hash[:details] << detail_hash
              end

              ret << hash
            end

            ret
          end

          # Gets protect/unprotect logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_unprotect_log(user = nil, title = nil, start = nil,
                                stop = nil, limit = 500)
            resp = get_log('protect/unprotect', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                user: log['user'],
                comment: log['comment'],
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
