# frozen_string_literal: true

module Searcher
  module Clients
    # http client for ElasticSearch
    class ElasticSearch
      def create(index = 'tmdb', mappings: {})
        Requests::ElasticSearch::CreateIndex.new(name: index, mappings: mappings).perform
      end

      def destroy(index = 'tmdb')
        Requests::ElasticSearch::DeleteIndex.new(name: index).perform
      end

      def index(data, index = 'tmdb', type = 'movie')
        Requests::ElasticSearch::FillIndex.new(name: index, type: type, data: data).perform
      end

      def reindex(data, index = 'tmdb', type = 'movie', mappings: {})
        destroy(index)
        create(index, mappings: mappings)
        index(data, index, type)
      end

      def search(query, index = 'tmdb', type = 'movie')
        Requests::ElasticSearch::Search.new(name: index, type: type, query: query).perform
      end

      def explain(query, index = 'tmdb', type = 'movie')
        Requests::ElasticSearch::Explain.new(name: index, type: type, query: query).perform
      end

      def analyze(field:, text:)
        Requests::ElasticSearch::Analyze.new(field: field, text: text).perform
      end
    end
  end
end
