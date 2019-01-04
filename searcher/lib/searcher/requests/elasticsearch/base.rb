# frozen_string_literal: true

require 'httparty'

module Searcher
  module Requests
    module ElasticSearch
      # base request class for http requests to ElasticSearch
      class Base
        include HTTParty

        attr_reader :index_name, :options

        base_uri 'http://localhost:9200'
      end
    end
  end
end
