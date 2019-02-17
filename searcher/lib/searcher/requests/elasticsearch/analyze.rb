# frozen_string_literal: true

require_relative 'base.rb'

module Searcher
  module Requests
    module ElasticSearch
      # sends analyze query to given ElasticSearch index
      class Analyze < Base
        attr_reader :headers, :url, :body

        def initialize(name: 'tmdb', field:, text:)
          @headers = { 'Content-Type' => 'application/json' }
          @url = File.join('/', name, '_analyze')
          @body = { field: field, text: text }.to_json
        end

        def perform
          self.class.get(url, headers: headers, body: body)
        end
      end
    end
  end
end
