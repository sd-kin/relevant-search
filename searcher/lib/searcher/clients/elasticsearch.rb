require 'httparty'

module Searcher
  module Clients
    # http client for ElasticSearch
    class ElasticSearch
      include HTTParty

      attr_reader :settings

      base_uri 'http://localhost:9200'

      def create(index = 'tmdb')
        Requests::ElasticSearch::CreateIndex.new(name: index).perform
      end

      def destroy(index = '/tmdb')
        self.class.delete(index)
      end

      def index(data, index = '/tmdb', type = 'movie')
        parsed_data = parse_data_for_bulk_index(data, index, type)
        headers = { 'Content-Type' => 'application/json' }
        self.class.post('/_bulk', headers: headers, body: parsed_data)
      end

      def reindex(data, index = 'tmdb', type = 'movie')
        destroy('/' + index)
        create(index)
        index(data, '/' + index, type)
      end

      def search(query, index = '/tmdb', type = 'movie')
        headers = { 'Content-Type' => 'application/json' }
        url = "#{index}/#{type}/_search"

        self.class.get(url, headers: headers, body: JSON.dump(query))
      end

      def explain(query, index = '/tmdb', type = 'movie')
        headers = { 'Content-Type' => 'application/json' }
        url = "#{index}/#{type}/_validate/query?explain"

        self.class.get(url, headers: headers, body: JSON.dump(query))
      end

      private

      def bulk_add_command(index, type, id)
        index.sub!('/', '')
        JSON.dump(index: { _index: index, _type: type, _id: id })
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
