# frozen_string_literal: true

module Searcher
  module Queries
    module ElasticSearch
      # query template for search in multiple fields
      class Multimatch
        attr_reader :query, :index, :type

        def initialize(term, fields: [], index: '/tmdb', type: 'movie', explain: nil, strategy: 'best_fields', tie_breaker: nil)
          @query = build_query(term, fields, explain, strategy, tie_breaker)
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

        def build_query(term, fields, explain, strategy, tie_breaker)
          query = {
            query: {
              multi_match: {
                query: term, fields: parse_fields(fields), type: strategy
              }
            }
          }
          query[:query][:multi_match][:tie_breaker] = tie_breaker if tie_breaker
          explain ? query.merge(explain: explain) : query
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
