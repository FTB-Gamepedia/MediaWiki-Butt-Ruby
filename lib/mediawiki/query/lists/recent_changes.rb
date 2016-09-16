require_relative 'users'

module MediaWiki
  module Query
    module Lists
      module RecentChanges
        include MediaWiki::Query::Lists::Users

        # Gets the RecentChanges log.
        # @param user [String] See {MediaWiki::Query::Lists::Log#get_log}
        # @param start [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
        # @param stop [DateTime] See {MediaWiki::Query::Lists::Log#get_log}
        # @param limit [Fixnum] See {MediaWiki::Query::Lists::Log#get_log}
        # @see https://www.mediawiki.org/wiki/API:RecentChanges MediaWiki RecentChanges API Docs
        # @since 0.10.0
        # @return [Array<Hash<Symbol, Any>>] All of the changes, with the following keys: type, title, revid,
        #   old_revid, rcid, user, old_length, new_length, diff_length, timestamp, comment, parsed_comment, sha, new,
        #   minor, bot.
        def get_recent_changes(user = nil, start = nil, stop = nil, limit = @query_limit_default)
          prop = 'user|comment|parsedcomment|timestamp|title|ids|sha1|sizes|redirect|flags|loginfo'
          rights = get_userrights
          patrol = false
          if rights != false && rights.include?('patrol')
            prop << '|patrolled'
            patrol = true
          end
          params = {
            action: 'query',
            list: 'recentchanges',
            rcprop: prop,
            rclimit: get_limited(limit)
          }
          params[:rcuser] = user unless user.nil?
          params[:rcstart] = start.xmlschema unless start.nil?
          params[:rcend] = stop.xmlschema unless stop.nil?

          post(params)['query']['recentchanges'].collect do |change|
            old_length = change['oldlen']
            new_length = change['newlen']
            diff_length = new_length - old_length

            hash = {
              type: change['type'],
              title: change['title'],
              revid: change['revid'],
              old_revid: change['old_revid'],
              rcid: change['rcid'],
              user: change['user'],
              old_length: old_length,
              new_length: new_length,
              diff_length: diff_length,
              timestamp: DateTime.xmlschema(change['timestamp']),
              comment: change['comment'],
              parsed_comment: change['parsedcomment'],
              sha: change['sha1']
            }
            hash[:new] = change.key?('new')
            hash[:minor] = change.key?('minor')
            hash[:bot] = change.key?('bot')

            hash[:patrolled] = change.key?('patrolled') if patrol

            if change['type'] == 'log'
              hash[:log_type] = change['logtype']
              hash[:log_action] = change['logaction']
              hash[:logid] = change['logid']
            end

            hash
          end
        end

        # Gets the recent deleted revisions.
        # @param (see #get_recent_changes)
        # @see https://www.mediawiki.org/wiki/API:Deletedrevs MediaWiki Deletedrevs API Docs
        # @since 0.10.0
        # @return [Array<Hash>] All of the changes, with the following keys: timestamp, user, comment, title.
        def get_recent_deleted_revisions(user = nil, start = nil, stop = nil, limit = @query_limit_default)
          prop = 'revid|parentid|user|comment|parsedcomment|minor|len|sh1|tags'
          params = {
            action: 'query',
            list: 'deletedrevs',
            drprop: prop,
            drlimit: get_limited(limit)
          }
          params[:drstart] = start.xmlschema unless start.nil?
          params[:drend] = stop.xmlschema unless stop.nil?

          post(params)['query']['deletedrevs'].collect do |rev|
            r = rev['revisions'][0]
            hash = {
              timestamp: DateTime.xmlschema(r['timestamp']),
              user: r['user'],
              comment: r['comment'],
              title: rev['title']
            }

            hash
          end
        end
      end
    end
  end
end
