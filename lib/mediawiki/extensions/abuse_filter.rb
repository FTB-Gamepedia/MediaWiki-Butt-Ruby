require_relative 'extension_module'

module MediaWiki
  module Extensions
    # @see https://www.mediawiki.org/wiki/Extension:AbuseFilter AbuseFilter docs
    module AbuseFilter
      include MediaWiki::Extensions::ExtensionModule

      # Gets the abuse log with the matching criteria.
      # @param user [String] The username to filter by.
      # @param title [String] The page title to filter.
      # @param filter [Int] The AbuseFilter ID to use.
      # @param limit [Int] The maximum logs to get.
      # @return [Hash] All valuable data: Filter ID, Username, edit count, age,
      #   whether they are on mobile, the page namespace, page title, action
      #   name, edit summary, added/removed content, whether the edit was minor,
      #   the action result, and a DateTime object of the filter time. Each
      #   sub-hash is keyed by the ID.
      def get_abuse_log(user = nil, title = nil, filter = nil, limit = 500)
        params = {
          action: 'query',
          list: 'abuselog',
          afllimit: get_limited(limit),
          aflprop: 'ids|user|title|action|result|timestamp|details'
        }
        params[:afluser] = user unless user.nil?
        params[:afltitle] = title unless title.nil?
        params[:aflfilter] = filter unless filter.nil?

        response = post(params)
        ret = {}
        timeformat = '%Y-%m-%dT%TZ'
        response['query']['abuselog'].each do |log|
          ret[log['id']] = {
            filter: log['filter_id'],
            user: {
              name: log['user'],
              mobile: false
            },
            namespace: log['ns'],
            page: log['title'],
            action: {
              type: log['action'],
              minor: false
            },
            result: log['result'],
            timestamp: DateTime.strptime(log['timestamp'], timeformat)
          }
          # If there are no details, log['details'] will be an empty array, so digging in it will cause a TypeError
          if log['details'].is_a? Hash
            ret[log['id']][:user][:mobile] = log['details'].key?('user_mobile')
            ret[log['id']][:user][:editcount] = log['details']['user_editcount']
            ret[log['id']][:user][:age] = log['details']['user_age']
            ret[log['id']][:action][:minor] = log['details'].key?('minor_edit')
            ret[log['id']][:action][:summary] = log['details']['summary']
            ret[log['id']][:action][:added] = log['details']['added_lines']
            ret[log['id']][:action][:removed] = log['details']['removed_lines']
          end
        end

        ret
      end

      # Gets the abuse filters on the wiki.
      # @param start [Int] The abuse filter ID to start at.
      # @param stop [Int] The abuse filter ID to stop at.
      # @param limit [Int] The maximum filters to get.
      # @return [Array<Hash>] An array of all of the abuse filters as hashes.
      def get_abuse_filters(start = nil, stop = nil, limit = 500)
        params = {
          action: 'query',
          list: 'abusefilters',
          abflimit: get_limited(limit),
          abfprop: 'id|description|pattern|actions|hits|comments|lasteditor|lastedittime|status|private'
        }
        params[:abfstartid] = start unless start.nil?
        params[:abfendid] = stop unless stop.nil?

        response = post(params)
        ret = []
        response['query']['abusefilters'].each do |filter|
          del = filter.delete('enabled')
          filter[:enabled] = !del.nil?
          filter = Hash[filter.map { |k, v| [k.to_sym, v] }]
          ret << filter
        end

        ret
      end
    end
  end
end
