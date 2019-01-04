# frozen_string_literal: true

module Searcher
  module Queries
    module ElasticSearch
      # query template for search in multiple fields
      class Multimatch
        attr_reader :query, :index, :type

        def initialize(term, fields: [], index: '/tmdb', type: 'movie')
          @query = { query: { multi_match: { query: term, fields: fields } } }
          @index = index
          @type = type
        end

        def perform
          client.search(query, index, type)
        end

        def explain
          client.explain(query, index, type)
        end

        private

        def client
          @client ||= Clients::ElasticSearch.new
        end
      end
    end
  end
end
