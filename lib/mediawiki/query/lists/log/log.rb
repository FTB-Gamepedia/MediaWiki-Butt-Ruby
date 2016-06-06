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
          time_format = MediaWiki::Constants::TIME_FORMAT
          params = {
            action: 'query',
            list: 'logevents',
            lelimit: get_limited(limit)
          }
          params[:leuser] = user unless user.nil?
          params[:letitle] = title unless title.nil?
          params[:lestart] = start.strftime(time_format) unless start.nil?
          params[:leend] = stop.strftime(time_format) unless stop.nil?
          response = post(params)

          ret = []
          response['query']['logevents'].each do |log|
            case log['type']
            when 'block'
              case log['action']
              when 'block'
                hash = get_blockblock(log)
              when 'unblock'
                hash = get_blockunblock(log)
              when 'reblock'
                hash = get_blockreblock(log)
              end
            when 'delete'
              case log['action']
              when 'delete', 'restore'
                hash = get_deletedelete(log)
              end
            when 'import'
              case log['action']
              when 'interwiki'
                hash = get_importinterwiki(log)
              when 'upload'
                hash = get_importupload(log)
              end
            when 'merge'
              case log['action']
              when 'merge'
                hash = get_mergemerge(log)
              end
            when 'move'
              case log['action']
              when 'move', 'move_redir'
                hash = get_move(log)
              end
            when 'newusers'
              case log['action']
              when 'autocreate', 'create', 'create2'
                hash = get_user(log)
              end
            when 'patrol'
              case log['action']
              when 'patrol'
                hash = get_patrol(log)
              end
            when 'protect'
              case log['action']
              when 'modify', 'protect'
                hash = get_protect(log)
              when 'move_prot'
                hash = get_protectmoveprot(log)
              when 'unprotect'
                hash = get_protectunprotect(log)
              end
            when 'rights'
              case log['action']
              when 'autopromote'
                hash = get_rightsautopromote(log)
              when 'rights'
                hash = get_rightsrights(log)
              end
            when 'upload'
              case log['action']
              when 'overwrite', 'upload'
                hash = get_upload(log)
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
          params[:lestart] = start.strftime(MediaWiki::Constants::TIME_FORMAT) unless start.nil?
          params[:leend] = stop.strftime(MediaWiki::Constants::TIME_FORMAT) unless stop.nil?
          post(params)
        end

        def get_block(log)
          {
            id: log['logid'],
            blocked: log['title'],
            flags: log['block']['flags'],
            duration: log['block']['duration'],
            expiry: DateTime.strptime(log['block']['expiry'],
                                      MediaWiki::Constants::TIME_FORMAT),
            blocker: log['user'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_unblock(log)
          {
            id: log['logid'],
            blocked: log['title'],
            blocker: log['user'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT),
            comment: log['comment']
          }
        end

        def get_importinterwiki(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT),
            count: log['params']['count'],
            interwiki_title: log['params']['interwiki_title']
          }
        end

        def get_general(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT),
            comment: log['comment']
          }
        end

        def get_merge(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            destination_title: log['params']['dest_title'],
            mergepoint: DateTime.strptime(log['params']['mergepoint'],
                                          MediaWiki::Constants::TIME_FORMAT),
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_move(log)
          hash = {
            id: log['logid'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }

          if log.key?('actionhidden')
            hash[:hidden] = true
            hash[:title] = nil
            hash[:comment] = nil
            hash[:suppressedredirect] = log.key('suppressed')
          else
            hash[:title] = log['title']
            hash[:new_title] = log['move']['new_title']
            hash[:user] = log['user']
            hash[:comment] = log['comment']

            hash[:suppressedredirect] = log['move'].key?('suppressedredirect')
          end

          hash
        end

        def get_user(log)
          {
            id: log['logid'],
            new_user: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_patrol(log)
          hash = {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            current_revision: log['patrol']['cur'],
            previous_revision: log['patrol']['prev'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
          auto = log['patrol']['auto']
          hash[:automatic] = auto == 1

          hash
        end

        def get_protect(log)
          time_format = MediaWiki::Constants::TIME_FORMAT
          hash = {
            id: log['logid'],
            title: log['title'],
            description: log['params']['description'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'], time_format)
          }

          hash[:details] = []

          log['params']['detail'].each do |detail|
            details_hash = {
              type: detail['type'],
              level: detail['level']
            }
            expire = detail['expiry']
            if expire != 'infinite'
              details_hash[:expiry] = DateTime.strptime(expire, time_format)
            end
            hash[:details] << detail_hash
          end

          hash
        end

        def get_protectmoveprot(log)
          {
            id: log['logid'],
            title: log['title'],
            old_title: log['params']['oldtitle_title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_protectunprotect(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_rightsautopromote(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            new_rights: log['rights']['new'].split(', '),
            old_rights: log['rights']['old'].split(', '),
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_rightsrights(log)
          {
            id: log['logid'],
            title: log['title'],
            to: log['title'],
            from: log['user'],
            new_rights: log['rights']['new'].split(', '),
            old_rights: log['rights']['old'].split(', '),
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end

        def get_upload(log)
          {
            id: log['logid'],
            title: log['title'],
            user: log['user'],
            sha: log['img_sha1'],
            comment: log['comment'],
            timestamp: DateTime.strptime(log['timestamp'],
                                         MediaWiki::Constants::TIME_FORMAT)
          }
        end
      end
    end
  end
end
