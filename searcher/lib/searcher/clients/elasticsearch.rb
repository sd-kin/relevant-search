require 'httparty'

module Searcher
  module Clients
    # http client for ElasticSearch
    class ElasticSearch
      include HTTParty

      base_uri 'http://localhost:9200'

      def create(index = 'tmdb')
        Requests::ElasticSearch::CreateIndex.new(name: index).perform
      end

      def destroy(index = 'tmdb')
        Requests::ElasticSearch::DeleteIndex.new(name: index).perform
      end

      def index(data, index = 'tmdb', type = 'movie')
        Requests::ElasticSearch::FillIndex.new(name: index, type: type, data: data).perform
      end

      def reindex(data, index = 'tmdb', type = 'movie')
        destroy(index)
        create(index)
        index(data, index, type)
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
    end
  end
end
