module MediaWiki
  module Query
    module Lists
      module Log
        # @todo upload/revert
        module Upload
          # Gets upload/overwrite logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, sha, comment, timestamp.
          def get_upload_overwrite_log(user = nil, title = nil, start = nil,
                                       stop = nil, limit = 500)
            resp = get_log('upload/overwrite', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                user: log['user'],
                sha: log['img_sha1'],
                comment: log['comment'],
                timestamp: DateTime.strptime(log['timestamp'],
                                             MediaWiki::Constants::TIME_FORMAT)
              }

              ret << hash
            end

            ret
          end

          # Gets upload/upload logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, sha, comment, timestamp.
          def get_upload_log(user = nil, title = nil, start = nil, stop = nil,
                             limit = 500)
            resp = get_log('upload/upload', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              hash = {
                id: log['logid'],
                title: log['title'],
                user: log['user'],
                sha: log['img_sha1'],
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
