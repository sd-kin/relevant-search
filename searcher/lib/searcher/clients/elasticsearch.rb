require 'httparty'

module Clients
  # TODO put it in Searcher namespace
  # http client for ElasticSearch
  class ElasticSearch
    include HTTParty

    attr_reader :settings

    base_uri 'http://localhost:9200'

    def initialize(analysis_settings: {}, mappings_settings: {})
      @settings = { settings: { number_of_shards: 1, index: {} } }
      settings.fetch(:settings).fetch(:index)[:analysis] = analysis_settings
      settings[:mappings] = mappings_settings
    end

    def create(index = '/tmdb')
      self.class.put(index, settings)
    end

    def destroy(index = '/tmdb')
      self.class.delete(index)
    end

    def index(data)
      self.class.post('/_bulk', headers: { 'Content-Type' => 'application/json' }, body: data)
    end

    def reindex(data)
      destroy
      create
      index(data)
    end
  end
end
