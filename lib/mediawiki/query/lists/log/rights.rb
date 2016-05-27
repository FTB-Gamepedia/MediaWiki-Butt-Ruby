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
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, new_rights, old_rights, comment, timestamp.
          def get_autopromotion_log(user = nil, title = nil, start = nil,
                                     stop = nil)
            resp = get_log('rights/autopromote', user, title, start, stop)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_rightsautopromote(log)
            end

            ret
          end

          # Gets rights/rights logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, to, from, new_rights, old_rights, comment, timestamp.
          def get_rights_log(user = nil, title = nil, start = nil, stop = nil)
            resp = get_log('rights/rights', user, title, start, stop)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_rightsrights(log)
            end

            ret
          end
        end
      end
    end
  end
end
