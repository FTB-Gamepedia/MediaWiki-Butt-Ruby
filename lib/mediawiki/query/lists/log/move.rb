module MediaWiki
  module Query
    module Lists
      module Log
        module Move
          # Gets move/move logs.
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
          def get_move_log(user = nil, title = nil, start = nil, stop = nil,
                           limit = 500)
            response = get_log('move/move', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_move(log)
            end

            ret
          end

          # Gets move/move_redir logs for redirects.
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
          def get_move_redirect_log(user = nil, title = nil, start = nil,
                                    stop = nil, limit = 500)
            resp = get_log('move/move_redir', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_move(log)
            end

            ret
          end
        end
      end
    end
  end
end
