# frozen_string_literal: true

require_relative 'base.rb'

module Searcher
  module Requests
    module ElasticSearch
      # adds given data to ElasticSearch index
      class FillIndex < Base
        attr_reader :headers, :body

        def initialize(data:, name:, type:)
          @body = prepare_request(data, name, type)
          @headers = { 'Content-Type' => 'application/json' }
        end

        def perform
          self.class.post('/_bulk', headers: headers, body: body)
        end

        private

        def prepare_request(data, index, type)
          data.reduce('') do |acc, (id, info)|
            index_info = JSON.generate(index: { _index: index, _type: type, _id: id })
            acc + index_info + "\n" + JSON.generate(info) + "\n"
          end
        end
      end
    end
  end
end
