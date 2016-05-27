module MediaWiki
  module Query
    module Lists
      module Log
        module Import
          # Gets import/interwiki logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, comment, timestamp, count, interwiki_title.
          def get_interwiki_import_log(user = nil, title = nil, start = nil,
                                       stop = nil)
            resp = get_log('import/interwiki', user, title, start, stop)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_importinterwiki(log)
            end

            ret
          end

          # Gets import/upload logs.
          # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param title [String] See {MediaWiki::Query::Lists::Log#get_log}
          # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
          # @see {MediaWiki::Query::Lists::Log#get_log}
          # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki
          #   Logevents API Docs
          # @since 0.10.0
          # @return [Array<Hash>] The events, containing the following keys: id,
          #   title, user, timestamp, comment.
          def get_upload_import_log(user = nil, title = nil, start = nil,
                                    stop = nil)
            resp = get_log('import/upload', user, title, start, stop)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << get_importupload(log)
            end

            ret
          end
        end
      end
    end
  end
end
