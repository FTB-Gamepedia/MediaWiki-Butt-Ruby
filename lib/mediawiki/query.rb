module MediaWiki
  module Query
    module Meta

      # Gets all raw names for the wiki's image repositories into an array.
      #
      # ==== Examples
      #
      # => names = butt.get_filerepo_names()
      def get_filerepo_names()
        params = {
          action: 'query',
          meta: 'filerepoinfo',
          friprop: 'name',
          format: 'json'
        }

        result = post(params)
        array = Array.new
        result["query"]["repos"].each do |repo|
          array.push(repo["name"])
        end
        return array
      end
    end
    module Properties

    end
    module Lists

    end
  end
end
