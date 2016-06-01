module MediaWiki
  module Query
    module Lists
      module Log
        module NewUsers
          # Gets newusers/autocreate logs.
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
          #   new_user, user, comment, timestamp.
          def get_autocreate_users_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            response = get_log('newusers/autocreate', user, title, start, stop,
                               limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_user(log)
            end

            ret
          end

          # Gets newusers/create2, when one user creates another user, logs.
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
          #   title, new_user, user, comment, timestamp.
          def get_user_create2_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('newusers/create2', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_user(log)
            end

            ret
          end

          # Gets newusers/create, when one user creates their own account, logs.
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
          def get_user_create_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('newusers/create', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_user(log)
            end

            ret
          end
        end
      end
    end
  end
end
