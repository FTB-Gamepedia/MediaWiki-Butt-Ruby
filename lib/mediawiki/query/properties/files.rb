require_relative '../query'

module MediaWiki
  module Query
    module Properties
      module Files
        # Gets the duplicated files of the title.
        # @param title [String] The title to get duplicated files of.
        # @see https://www.mediawiki.org/wiki/API:Duplicatefiles MediaWiki
        #   Duplicate Files API Docs
        # @since 0.8.0
        # @return [Array] Array of all the duplicated file names.
        # @return [Nil] If there aren't any duplicated files.
        def get_duplicated_files_of(title)
          params = {
            action: 'query',
            prop: 'duplicatefiles',
            titles: title,
            dflimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |_, c|
            return nil if c['duplicatefiles'].nil?
            c['duplicatefiles'].each do |f|
              ret.push(f['name'])
            end
          end
          ret
        end

        # Gets all duplicated files on the wiki.
        # @see https://www.mediawiki.org/wiki/API:Duplicatefiles MediaWiki
        #   Duplicate Files API Docs
        # @since 0.8.0
        # @return [Array] All duplicate file titles on the wiki.
        def get_all_duplicated_files
          params = {
            action: 'query',
            generator: 'allimages',
            prop: 'duplicatefiles',
            dflimit: get_limited(@query_limit)
          }

          response = post(params)
          ret = []
          response['query']['pages'].each do |_, c|
            ret.push(c['title'])
          end
          ret
        end

        # Gets the size of an image in bytes.
        # @param image [String] The image to get info for.
        # @see get_image_sizes
        # @since 0.8.0
        # @return [Fixnum] The number of bytes.
        # @return [Nil] If the image does not exist.
        def get_image_bytes(image)
          response = get_image_sizes(image)
          return nil if response.nil?
          response['size']
        end

        # Gets the dimensions of an image as width, height.
        # @param image [String] The image to get info for.
        # @see get_image_sizes
        # @since 0.8.0
        # @return [Array] The dimensions as width, height.
        # @return [Nil] If the image does not exist.
        def get_image_dimensions(image)
          response = get_image_sizes(image)
          return nil if response.nil?
          [response['width'], response['height']]
        end

        private

        # Gets the imageinfo property 'size' for the image.
        # @param image [String] The image to get info for.
        # @see https://www.mediawiki.org/wiki/API:Imageinfo MediaWiki Imageinfo
        #   API Docs
        # @since 0.8.0
        # @return [Hash] A hash of the size, width, and height.
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
