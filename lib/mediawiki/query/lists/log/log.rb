require 'date'
require_relative '../../../constants'
require_relative 'block'
require_relative 'delete'
require_relative 'import'
require_relative 'merge'
require_relative 'move'
require_relative 'newusers'
require_relative 'patrol'
require_relative 'protect'
require_relative 'rights'
require_relative 'upload'

module MediaWiki
  module Query
    module Lists
      module Log
        include MediaWiki::Query::Lists::Log::Block
        include MediaWiki::Query::Lists::Log::Delete
        include MediaWiki::Query::Lists::Log::Import
        include MediaWiki::Query::Lists::Log::Merge
        include MediaWiki::Query::Lists::Log::Move
        include MediaWiki::Query::Lists::Log::NewUsers
        include MediaWiki::Query::Lists::Log::Patrol
        include MediaWiki::Query::Lists::Log::Protect
        include MediaWiki::Query::Lists::Log::Rights
        include MediaWiki::Query::Lists::Log::Upload

        # Gets the general log as seen in Special:Log. Since not every single log type possible can be supported,
        # non-default MW logs will be represented exactly as provided by the API, with the :skipped key as true.
        # @param user [String] The user to filter by.
        # @param title [String] The title to filter by.
        # @param start [DateTime] Where to start the log events at.
        # @param stop [DateTime] Where to end the log events.
        # @param limit [Fixnum] The limit, maximum 500 for users or 5000 for bots.
        # @see #get_log
        # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki Logevents API Docs
        # @since 0.10.0
        # @return [Array<Hash>] All the log events.
        def get_overall_log(user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'logevents',
            lelimit: get_limited(limit)
          }
          params[:leuser] = user unless user.nil?
          params[:letitle] = title unless title.nil?
          params[:lestart] = start.xmlschema unless start.nil?
          params[:leend] = stop.xmlschema unless stop.nil?
          response = post(params)

          ret = []
          response['query']['logevents'].each do |log|
            case log['type']
            when 'block'
              case log['action']
              when 'block', 'reblock'
                hash = loghash_block(log)
              when 'unblock'
                hash = loghash_unblock(log)
              end
            when 'delete'
              case log['action']
              when 'delete', 'restore'
                hash = loghash_general(log)
              end
            when 'import'
              case log['action']
              when 'interwiki'
                hash = loghash_importinterwiki(log)
              when 'upload'
                hash = loghash_importupload(log)
              end
            when 'merge'
              case log['action']
              when 'merge'
                hash = loghash_merge(log)
              end
            when 'move'
              case log['action']
              when 'move', 'move_redir'
                hash = loghash_move(log)
              end
            when 'newusers'
              case log['action']
              when 'autocreate', 'create', 'create2'
                hash = loghash_user(log)
              end
            when 'patrol'
              case log['action']
              when 'patrol'
                hash = loghash_patrol(log)
              end
            when 'protect'
              case log['action']
              when 'modify', 'protect'
                hash = loghash_protect(log)
              when 'move_prot'
                hash = loghash_protectmoveprot(log)
              when 'unprotect'
                hash = loghash_protectunprotect(log)
              end
            when 'rights'
              case log['action']
              when 'autopromote'
                hash = loghash_rightsautopromote(log)
              when 'rights'
                hash = loghash_rightsrights(log)
              end
            when 'upload'
              case log['action']
              when 'overwrite', 'upload'
                hash = loghash_upload(log)
              end
            end

            hash = log if hash.nil?

            type = "#{log['type']}/#{log['action']}"

            hash[:type] = type
            hash[:skipped] = false unless hash.key(:skipped)

            ret << hash
          end

          ret
        end

        private

        # Gets log events.
        # @param action [String] The action, e.g., block/block.
        # @param (see #get_overall_log)
        # @see https://www.mediawiki.org/wiki/API:Logevents MediaWiki Logevents API Docs
        # @since 0.10.0
        # @return [Hash] The response.
        def get_log(action, user = nil, title = nil, start = nil, stop = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'logevents',
            leaction: action,
            lelimit: get_limited(limit)
          }
          params[:leuser] = user unless user.nil?
          params[:letitle] = title unless title.nil?
          params[:lestart] = start.xmlschema unless start.nil?
          params[:leend] = stop.xmlschema unless stop.nil?
          post(params)
        end

        def loghash_block(log)
          hash = {
            id: log['logid'],
            blocked: log['title'],
            flags: log['params']['flags'],
            duration: log['params']['duration'],
            blocker: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
          hash[:expiry] = DateTime.xmlschema(log['params']['expiry']) if log['params'].key?('expiry')

          hash
        end

        def loghash_unblock(log)
          {
            id: log['logid'],
            blocked: log['title'],
            blocker: log['user'],
            timestamp: DateTime.xmlschema(log['timestamp']),
            comment: log['comment']
          }
        end

        def loghash_importinterwiki(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp']),
            count: log['params']['count'],
            interwiki_title: log['params']['interwiki_title']
          }
        end

        def loghash_importupload(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp']),
            count: log['params']['count']
          }
        end

        def loghash_general(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            timestamp: DateTime.xmlschema(log['timestamp']),
            comment: log['comment']
          }
        end

        def loghash_merge(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            destination_title: log['params']['dest_title'],
            mergepoint: DateTime.xmlschema(log['params']['mergepoint']),
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_move(log)
          hash = {
            id: log['logid'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }

          if log.key?('actionhidden')
            hash[:hidden] = true
            hash[:old_title] = nil
            hash[:comment] = nil
            hash[:suppressedredirect] = log.key('suppressed')
          else
            hash[:old_title] = log['title']
            hash[:new_title] = log['params']['target_title']
            hash[:user] = log['user']
            hash[:comment] = log['comment']

            hash[:suppressedredirect] = log['params'].key?('suppressedredirect')
          end

          hash
        end

        def loghash_user(log)
          {
            id: log['logid'],
            new_user: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_patrol(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            current_revision: log['params']['curid'],
            previous_revision: log['params']['previd'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_protect(log)
          hash = {
            id: log['logid'],
            title: log['title'],
            description: log['params']['description'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }

          hash[:details] = []

          # It appears that older protection logs did not have a details key.
          if log['params'].key?('details')
            log['params']['details'].each do |detail|
              details_hash = {
                type: detail['type'],
                level: detail['level']
              }
              expire = detail['expiry']
              if expire != 'infinite'
                details_hash[:expiry] = DateTime.xmlschema(expire)
              end
              hash[:details] << details_hash
            end
          end

          hash
        end

        def loghash_protectmoveprot(log)
          {
            id: log['logid'],
            title: log['title'],
            old_title: log['params']['oldtitle_title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_protectunprotect(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_rightsautopromote(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            new_rights: log['params']['newgroups'],
            old_rights: log['params']['oldgroups'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_rightsrights(log)
          {
            id: log['logid'],
            title: log['title'],
            to: log['title'],
            from: log['user'],
            new_rights: log['params']['newgroups'],
            old_rights: log['params']['oldgroups'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end

        def loghash_upload(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            sha: log['img_sha1'],
            comment: log['comment'],
            timestamp: DateTime.xmlschema(log['timestamp'])
          }
        end
      end
    end
  end
end
