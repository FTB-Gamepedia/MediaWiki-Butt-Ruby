module MediaWiki
  module Query
    module Lists
      module Log
        # @todo rights/erevoke
        module Rights
          # Gets rights/autopromote logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash<Symbol, Any>>] The events, containing the following keys: id, title, user,
          #   new_rights, old_rights, comment, timestamp.
          def get_autopromotion_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('rights/autopromote', user, title, start, stop,
                           limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << loghash_rightsautopromote(log)
            end

            ret
          end

          # Gets rights/rights logs.
          # @param (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @see (see MediaWiki::Query::Lists::Log::Block#get_block_log)
          # @since 0.10.0
          # @return [Array<Hash<Symbol, Any>>] The events, containing the following keys: id, title, to, from,
          #   new_rights, old_rights, comment, timestamp.
          def get_rights_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
            resp = get_log('rights/rights', user, title, start, stop, limit)

            ret = []
            resp['query']['logevents'].each do |log|
              ret << loghash_rightsrights(log)
            end

            ret
          end
        end
      end
    end
  end
end
