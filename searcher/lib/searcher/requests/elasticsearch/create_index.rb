require 'httparty'

module Searcher
  module Requests
    module ElasticSearch
      # create ElasticSearch index with given name and options
      class CreateIndex
        include HTTParty

        attr_reader :index_name, :options

        base_uri 'http://localhost:9200'

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
