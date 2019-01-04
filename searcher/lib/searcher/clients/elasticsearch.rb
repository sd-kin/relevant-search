# frozen_string_literal: true

module Searcher
  module Clients
    # http client for ElasticSearch
    class ElasticSearch
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

      def search(query, index = 'tmdb', type = 'movie')
        Requests::ElasticSearch::Search.new(name: index, type: type, query: query).perform
      end

      def explain(query, index = 'tmdb', type = 'movie')
        Requests::ElasticSearch::Explain.new(name: index, type: type, query: query).perform
      end
    end
  end
end
