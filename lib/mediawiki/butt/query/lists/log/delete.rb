module MediaWiki
  module Query
    module Lists
      module Log
        # @todo delete/event
        # @todo delete/revision
        module Delete
          # Gets delete/delete logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_delete_log(user = nil, title = nil, start = nil, stop = nil,
                             limit = 500)
            response = get_log('delete/delete', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_general(log)
            end

            ret
          end

          # Gets delete/restore logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param limit [Int] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp.
          def get_deletion_restore_log(user = nil, title = nil, start = nil,
                                       stop = nil, limit = 500)
            resp = get_log('delete/restore', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_general(log)
            end

            ret
          end
        end
      end
    end
  end
end
