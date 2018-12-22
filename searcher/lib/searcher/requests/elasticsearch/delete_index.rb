require_relative 'base.rb'

module Searcher
  module Requests
    module ElasticSearch
      # delete ElasticSearch index with given name and options
      class DeleteIndex < Base
        def initialize(name: 'tmdb')
          @index_name = name
        end

        def perform
          self.class.delete('/' + index_name)
        end
      end
    end
  end
end
