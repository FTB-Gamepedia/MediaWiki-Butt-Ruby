require_relative '../query'

module MediaWiki
  module Query
    module Properties
      module Files
        # Gets the duplicated files of the title.
        # @param title [String] The title to get duplicated files of.
        # @param (see #get_all_duplicated_files)
        # @see https://www.mediawiki.org/wiki/API:Duplicatefiles MediaWiki Duplicate Files API Docs
        # @since 0.8.0
        # @return [Array<String>] Array of all the duplicated file names.
        def get_duplicated_files_of(title, limit = @query_limit_default)
          params = {
            prop: 'duplicatefiles',
            titles: title,
            dflimit: get_limited(limit)
          }

          query(params) do |return_val, query|
            query['pages'].each do |_, c|
              next unless c['duplicatefies']
              c['duplicatefiles'].each { |f| return_val << f['name'] }
            end
          end
        end

        # Gets all duplicated files on the wiki.
        # @param limit [Fixnum] The maximum number of files to get.
        # @see (see #get_duplicate_files_of)
        # @since 0.8.0
        # @return [Array<String>] All duplicate file titles on the wiki.
        def get_all_duplicated_files(limit = @query_limit_default)
          params = {
            generator: 'allimages',
            prop: 'duplicatedfiles',
            dflimit: get_limited(limit)
          }

          query_ary(params, 'pages', 'title')
        end

        # Gets the size of an image in bytes.
        # @param (see #get_image_sizes)
        # @see #get_image_sizes
        # @since 0.8.0
        # @return [Fixnum] The number of bytes.
        # @return [Nil] If the image does not exist.
        def get_image_bytes(image)
          response = get_image_sizes(image)
          return nil if response.nil?
          response['size']
        end

        # Gets the dimensions of an image as width, height.
        # @param (see #get_image_sizes)
        # @see #get_image_sizes
        # @since 0.8.0
        # @todo Use data_types library to store the pair of width, height.
        # @return [Array<Fixnum>] The dimensions as width, height.
        # @return [Nil] If the image does not exist.
        def get_image_dimensions(image)
          response = get_image_sizes(image)
          return nil if response.nil?
          [response['width'], response['height']]
        end

        private

        # Gets the imageinfo property 'size' for the image.
        # @param image [String] The image to get info for.
        # @see https://www.mediawiki.org/wiki/API:Imageinfo MediaWiki Imageinfo API Docs
        # @since 0.8.0
        # @return [Hash<String, Fixnum>] A hash of the size, width, and height.
        # @return [Nil] If the image does not exist.
        def get_image_sizes(image)
          params = {
            action: 'query',
            prop: 'imageinfo',
            iiprop: 'size',
            titles: image
          }

          response = post(params)
          pageid = nil
          response['query']['pages'].each { |r, _| pageid = r }
          return nil if pageid == '-1'
          ret = {}
          response['query']['pages'][pageid]['imageinfo'].each do |i|
            i.each { |k, v| ret[k] = v }
          end
          ret
        end
      end
    end
  end
end
