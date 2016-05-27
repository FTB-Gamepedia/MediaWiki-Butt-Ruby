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
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, current_revision, previous_revision,
          #   timestamp.
          def get_patrol_log(user = nil, title = nil, start = nil, stop = nil)
            response = get_log('patrol/patrol', user, title, start, stop)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_patrol(log)
            end

            ret
          end
        end
      end
    end
  end
end
