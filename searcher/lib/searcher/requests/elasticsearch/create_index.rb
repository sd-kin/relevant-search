# frozen_string_literal: true

require_relative 'base.rb'

module Searcher
  module Requests
    module ElasticSearch
      # create ElasticSearch index with given name and options
      class CreateIndex < Base
        attr_reader :headers

        def initialize(name: 'tmdb', config: {}, mappings: {}, analysis: {})
          @headers = { 'Content-Type' => 'application/json' }
          @index_name = name
          @options = {
            settings: {
              index: config.merge(number_of_shards: 1),
              analysis: analysis
            },
            mappings: mappings
          }
        end

        def perform
          self.class.put('/' + index_name, headers: headers, body: options.to_json)
        end
      end
    end
  end
end
