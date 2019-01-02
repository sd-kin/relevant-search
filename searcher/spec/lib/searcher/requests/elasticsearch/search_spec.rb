require 'spec_helper'

describe Searcher::Requests::ElasticSearch::Search do
  describe '.new' do
    subject(:search_request) do
      described_class.new(name: 'test_index', type: 'some_type', query: { title: 'test' })
    end

    it 'has json headers' do
      expect(search_request.headers).to eq({ 'Content-Type' => 'application/json' })
    end

    it 'has correct url for given index and type' do
      expect(search_request.url).to eq('/test_index/some_type/_search')
    end

    it 'generates json body' do
      expect(search_request.body).to eq('{"title":"test"}')
    end
  end

  describe '#perform' do
    let(:search_request) { described_class.new(name: 'test_index', type: 'some_type', query: 'test') }
    subject(:perform_search) { search_request.perform }

    it 'sends correct request' do
      expect(described_class)
        .to receive(:get)
        .with(search_request.url, headers: search_request.headers, body: search_request.body)

      perform_search
    end
  end
end
