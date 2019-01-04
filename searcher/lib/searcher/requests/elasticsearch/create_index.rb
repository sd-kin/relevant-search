# frozen_string_literal: true

require_relative 'base.rb'

module Searcher
  module Requests
    module ElasticSearch
      # create ElasticSearch index with given name and options
      class CreateIndex < Base
        def initialize(name: 'tmdb', config: {}, mappings: {})
          @index_name = name
          @options = { mappings: mappings }
          options[:config] = config.merge(number_of_shards: 1)
        end

        def perform
          self.class.put('/' + index_name, options)
        end
      end
    end
  end
end
