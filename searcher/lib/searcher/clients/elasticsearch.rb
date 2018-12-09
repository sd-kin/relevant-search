require 'httparty'

module Searcher
  module Clients
    # http client for ElasticSearch
    class ElasticSearch
      include HTTParty

      attr_reader :settings

      base_uri 'http://localhost:9200'

      def initialize(analysis_settings: {}, mappings_settings: {})
        @settings = { settings: { number_of_shards: 1, index: {} } }
        settings.fetch(:settings).fetch(:index)[:analysis] = analysis_settings
        settings[:mappings] = mappings_settings
      end

      def create(index = '/tmdb')
        self.class.put(index, settings)
      end

      def destroy(index = '/tmdb')
        self.class.delete(index)
      end

      def index(data, index = '/tmdb', type = 'movie')
        parsed_data = parse_data_for_bulk_index(data, index, type)
        headers = { 'Content-Type' => 'application/json' }
        self.class.post('/_bulk', headers: headers, body: parsed_data)
      end

      def reindex(data, index = '/tmdb', type = 'movie')
        destroy(index)
        create(index)
        index(data, index, type)
      end

      private

      def bulk_add_command(index, type, id)
        index.sub!('/', '')
        JSON.dump({ index: { _index: index, _type: type, _id: id } })
      end

      def parse_data_for_bulk_index(data, index, type)
        bulk_movies = ''

        data.each do |id, film|
          add_cmd = bulk_add_command(index, type, id)
          bulk_movies += add_cmd + "\n" + JSON.dump(film) + "\n"
        end

        bulk_movies
      end
    end
  end
end
