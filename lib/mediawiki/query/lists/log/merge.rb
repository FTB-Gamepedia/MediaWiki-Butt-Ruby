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
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, destination_title, mergepoint, timestamp.
          def get_merge_log(user = nil, title = nil, start = nil, stop = nil,
                             limit = 500)
            response = get_log('merge/merge', user, title, start, stop, limit)

            ret = []
            response['query']['logevents'].each do |log|
              ret << get_mergemerge(log)
            end

            ret
          end
        end
      end
    end
  end
end
