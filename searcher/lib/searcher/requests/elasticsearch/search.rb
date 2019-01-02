require_relative 'base.rb'

module Searcher
  module Requests
    module ElasticSearch
      # sends search query to given ElasticSearch index
      class Search < Base
        attr_reader :headers, :url, :body

        def initialize(name: , type: , query: )
          @headers = { 'Content-Type' => 'application/json' }
          @url = File.join('/', name, type, '_search')
          @body = JSON.generate(query)
        end

        def perform
          self.class.get(url, headers: headers, body: body)
        end
      end
    end
  end
end
