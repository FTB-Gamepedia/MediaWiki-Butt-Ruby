require 'data_types/pair'

module MediaWiki
  module Extension
    module Tilesheets
      # Creates a new blank tilesheet.
      # @param mod [String] The mod abbreviation.
      # @param sizes [Array<Integer>] All of the sizes for this tilesheet.
      # @param summary [String] The edit summary.
      # @return [Boolean] Whether the sheet was created successfully.
      def create_new_tilesheet(mod, sizes = [16, 32], summary = '')
        params = {
          action: 'createsheet',
          tsmod: mod,
          tssizes: sizes.join('|'),
          tstoken: get_token('edit'),
          tssummary: summary
        }

        response = post(params)
        return !response['edit']['createsheet'].is_a?(Array)
      end

      # Deletes a tilesheet.
      # @param mod [String] The mod abbreviation.
      # @param summary [String] The edit summary.
      # @return [Boolean] True, always, because of an issue with the API itself.
      def delete_tilesheet(mod, summary = '')
        params = {
          action: 'deletesheet',
          tsmod: mod,
          tssummary: summary,
          tstoken: get_token('edit')
        }

        # @todo fix the Tilesheets API. See HydraWiki/Tilesheets#16
        post(params)
        return true
      end

      # Creates a new tile in the tilesheet.
      # @param mod [String] The mod abbreviation.
      # @param name [String] The item name.
      # @param coordinates [Pair] A pair representing the X, Y coordinates.
      # @param summary [String] The edit summary.
      # @return [Boolean] Whether the tile was added successfully.
      def create_new_tile(mod, name, coordinates, summary = '')
        params = {
          action: 'addtile',
          tsmod: mod,
          tsname: name,
          tsx: coordinates.left,
          tsy: coordinates.right,
          tssummary: summary,
          tstoken: get_token('edit')
        }

        response = post(params)
        return !response['edit']['addtile'].is_a?(Array)
      end

      # Deletes a set of tiles by their entry IDs.
      # @param ids [Array<Integer>] The entry IDs to delete.
      # @param summary [String] The edit summary.
      # @return [Boolean] False when the entire deletion failed, or when every entry failed to be deleted.
      # @return [Hash<Integer, Boolean>] The ID and whether it was successful or not.
      def delete_tiles(ids, summary = '')
        params = {
          action: 'deletetiles',
          tsids: ids.join('|'),
          tssummary: summary,
          tstoken: get_token('edit')
        }

        response = post(params)
        return false if response['edit']['deletetiles'].is_a?(Array)
        ret = {}
        ids.each do |id|
          ret[id] = response['edit']['deletetiles'].key?(id.to_s)
        end

        ret
      end

      # Edits a tilesheet's entry data.
      # @param mod [String] The current mod abbreviation, before the edit.
      # @param new_mod [String] The new mod abbreviation.
      # @param new_sizes [Array<Integer>] The new sizes for the sheet.
      # @param summary [String] The edit summary.
      # @return [Boolean] False if the new_mod and new_sizes were not set.
      # @return [String] An error code if any.
      # @return [Hash<String, String>] A hash representing old data -> new data.
      def edit_sheet(mod, new_mod = nil, new_sizes = nil, summary = '')
        params = {
          action: 'editsheet',
          tstoken: get_token('edit'),
          tssummary: summary,
          tsmod: mod
        }
        params[:tstomod] = new_mod unless new_mod.nil?
        params[:tstosizes] = new_sizes.join('|') unless new_sizes.nil?

        return false if !params.key?(:tstomod) && !params.key?(:tstosizes)

        response = post(params)
        return response['error']['code'] if response.key?('error')
        return response['edit']['edittile']
      end

      # Edits a tile's entry data.
      # @param id [Integer] The entry ID
      # @param new_name [String] The new item name for the entry.
      # @param new_mod [String] The new mod abbreviation for the entry.
      # @param new_coordinates [Pair] The new set of X, Y coordinates on the sheet.
      # @param summary [String] The edit summary.
      # @return [Boolean] False if new_name, new_mod, and new_coordiantes were not set (or were empty)
      # @return [String] The error code if any.
      # @return [Boolean] Whether the edit was successful.
      def edit_tile(id, new_name = nil, new_mod = nil, new_coordinates = nil, summary = '')
        return false if new_name.nil? && new_mod.nil? && (new_coordinates.nil? || new_coordinates.empty?)
        params = {
          action: 'edittile',
          tstoken: get_token('edit'),
          tssummary: summary,
          tsid: id
        }
        params[:tstoname] = new_name unless new_name.nil?
        params[:tstomod] = new_mod unless new_mod.nil?
        if !new_coordinates.nil? && !new_coordinates.empty?
          unless new_coordinates.left.nil?
            params[:tstox] = new_coordinates.left
          end
          unless new_coordinates.right.nil?
            params[:tstoy] = new_coordinates.right
          end
        end

        response = post(params)
        return response['error']['code'] if response.key?('error')
        return !response['edit']['edittile'].is_a?(Array)
      end

      # Gets a list of tilesheets on the wiki.
      # @param start [String] The abbreviation to start at.
      # @param limit [Integer] The maximum number of sheets to get.
      # @return [Array<Hash>] An array of hash representations of the sheets, 
      #   containing :mod (String) and :sizes (Array<Integer>).
      def get_tilesheets(start = nil, limit = 500)
        params = {
          action: 'query',
          list: 'tilesheets',
          tslimit: MediaWiki::Query.get_limited(limit)
        }
        params[:tsstart] = start unless start.nil?

        response = post(params)
        ret = []
        response['query']['tilesheets'].each do |sheet|
          ret << Hash[sheet.map { |k, v| [k.to_sym, v] }]
        end

        ret
      end

      # Gets a list of tile entries.
      # @param mod [String] The mod abbreviation to get the entries from.
      # @param start [Integer] The ID to start at.
      # @param limit [Integer] The maximum number of tiles to get.
      # @return [Array<Hash>] An array of hashes containing data for the tiles, including:
      #   id: Integer
      #   mod: String
      #   name: String
      #   coordinates: Pair<Integer, Integer>
      def get_tiles(mod = nil, start = nil, limit = 500)
        params = {
          action: 'query',
          list: 'tiles',
          tslimit: MediaWiki::Query.get_limited(limit)
        }
        params[:tsstart] = start unless start.nil?
        params[:tsmod] = mod unless mod.nil?

        response = post(params)
        ret = []
        response['query']['tiles'].each do |id, data|
          ret << {
            id: id.to_i,
            mod: data['mod'],
            name: data['name'],
            coordinates: Pair.new(data['x'], data['y'])
          }
        end

        ret
      end
    end
  end
end