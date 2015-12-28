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
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, description, user, comment, timestamp, details.
          def get_modify_protection_log(user = nil, title = nil, start = nil,
                                        stop = nil, limit = 500)
            response = get_log('protect/modify', user, title, start, stop,
                               limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_protect(log)
            end

            ret
          end

          # Gets protect/move_prot logs.
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
          #   title, old_title, user, comment, timestamp.
          def get_move_protected_log(user = nil, title = nil, start = nil,
                                     stop = nil, limit = 500)
            resp = get_log('protect/move_prot', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_protectmoveprot(log)
            end

            ret
          end

          # Gets protect/protect logs.
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
          #   title, description, user, comment, timestamp, details.
          def get_protect_log(user = nil, title = nil, start = nil, stop = nil,
                              limit = 500)
            response = get_log('protect/protect', user, title, start, stop,
                               limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_protect(log)
            end

            ret
          end

          # Gets protect/unprotect logs.
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
          def get_unprotect_log(user = nil, title = nil, start = nil,
                                stop = nil, limit = 500)
            resp = get_log('protect/unprotect', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_protectunprotect(log)
            end

            ret
          end
        end
      end
    end
  end
end
