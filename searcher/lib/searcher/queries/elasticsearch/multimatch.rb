# frozen_string_literal: true

module Searcher
  module Queries
    module ElasticSearch
      # query template for search in multiple fields
      class Multimatch
        attr_reader :query, :index, :type

        def initialize(term, fields: [], index: '/tmdb', type: 'movie', explain: false)
          @query = build_query(term, fields, explain)
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

        def build_query(term, fields, explain)
          {
            query: { multi_match: { query: term, fields: parse_fields(fields) } },
            explain: explain
          }
        end

        def parse_fields(fields)
          fields.map do |field|
            if field.instance_of?(Hash)
              field.reduce([]) { |acc, (k, v)| acc << "#{k}^#{v}" }
            else
              field
            end
          end.flatten
        end

        def client
          @client ||= Clients::ElasticSearch.new
        end
      end
    end
  end
end
