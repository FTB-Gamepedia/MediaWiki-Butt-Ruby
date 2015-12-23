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

        private

        # Gets log events.
        # @param action [String] The action, e.g., block/block.
        # @param user [String] The user to filter by.
        # @param title [String] The title to filter by.
        # @param start [DateTime] Where to start the log events at.
        # @param stop [DateTime] Where to end the log events.
        # @param limit [Int] The limit, maximum 500 for users or 5000 for bots.
        # @return [JSON] The response json.
        def get_log(action, user = nil, title = nil, start = nil, stop = nil,
                    limit = 500)
          params = {
            action: 'query',
            list: 'logevents',
            leaction: action,
            lelimit: get_limited(limit)
          }
          params[:leuser] = user unless user.nil?
          params[:letitle] = title unless user.nil?
          params[:lestart] = start.strftime(MediaWiki::Constants::TIME_FORMAT) unless start.nil?
          params[:leend] = stop.strftime(MediaWiki::Constants::TIME_FORMAT) unless stop.nil?
          post(params)
        end
      end
    end
  end
end
