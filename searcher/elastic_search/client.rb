require 'httparty'
# http client for ElasticSearch
module ElasticSearch
  class Client
    include HTTParty

    attr_reader :settings

    base_uri 'http://localhost:9200'

    def initialize(analysis_settings: {}, mappings_settings: {})
      @settings = { settings: { number_of_shards: 1, index: {} } }
      @settings[:settings][:index][:analysis] = analysis_settings if analysis_settings
      @settings[:mappings] = mappings_settings if mappings_settings
    end

    def reindex(index = '/tmdb', data = TMDB.parse_data_for_bulk_index)
      destroy
      create
      index(data)
    end

    def create(index = '/tmdb')
      self.class.put(index, settings)
    end

    def destroy(index = '/tmdb')
      self.class.delete(index)
    end

    def index(data = TMDB.parse_data_for_bulk_index)
      self.class.post('/_bulk', headers: { 'Content-Type' => 'application/json' }, body: data)
    end
  end
end
