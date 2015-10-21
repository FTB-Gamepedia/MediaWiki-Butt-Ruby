module MediaWiki
  module Query
    module Properties
      module Files
        # Gets the duplicated files of the title.
        # @param title [String] The title to get duplicated files of.
        # @param limit [Int] The maximum number of files to get.
        # @return [Array/Nil] Array of all the duplicated file names, or nil if
        #   there aren't any.
        def get_duplicated_files_of(title, limit = 500)
          params = {
            action: 'query',
            prop: 'duplicatefiles',
            titles: title,
            dflimit: MediaWiki::Query.get_limited(limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |_, c|
            if c['duplicatefiles'].nil?
              return nil
            end
            c['duplicatefiles'].each do |f|
              ret.push(f['name'])
            end
          end
          ret
        end

        # Gets all duplicated files on the wiki.
        # @param limit [Int] The maximum number of files to get.
        # @return [Array] All duplicate file titles on the wiki.
        def get_all_duplicated_files(limit = 500)
          params = {
            action: 'query',
            generator: 'allimages',
            prop: 'duplicatefiles',
            dflimit: MediaWiki::Query.get_limited(limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |_, c|
            ret.push(c['title'])
          end
          ret
        end
      end
    end
  end
end
