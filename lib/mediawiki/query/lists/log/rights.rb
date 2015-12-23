module MediaWiki
  module Query
    module Lists
      module Log
        # @todo rights/erevoke
        module Rights
          # Gets rights/autopromote logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, new_rights, old_rights, comment, timestamp.
          def get_autopromotion_log(user = nil, title = nil, start = nil,
                                     stop = nil, limit = 500)
            resp = get_log('rights/autopromote', user, title, start, stop,
                           limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                user: log['user'],
                new_rights: log['rights']['new'].split(', '),
                old_rights: log['rights']['old'].split(', '),
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              ret << hash
            end

            ret
          end

          # Gets rights/rights logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, to, from, new_rights, old_rights, comment, timestamp.
          def get_rights_log(user = nil, title = nil, start = nil, stop = nil,
                             limit = 500)
            resp = get_log('rights/rights', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                to: log['title'],
                from: log['user'],
                new_rights: log['rights']['new'].split(', '),
                old_rights: log['rights']['old'].split(', '),
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
