# frozen_string_literal: true

require 'spec_helper'

describe Searcher::Requests::ElasticSearch::Explain do
  describe '.new' do
    subject(:explain_request) do
      described_class.new(name: 'test_index', type: 'some_type', query: { title: 'test' })
    end

    it 'has json headers' do
      expect(explain_request.headers).to eq('Content-Type' => 'application/json')
    end

    it 'has correct url for given index and type' do
      expect(explain_request.url).to eq('/test_index/some_type/_validate/query?explain')
    end

    it 'generates json body' do
      expect(explain_request.body).to eq('{"title":"test"}')
    end
  end

  describe '#perform' do
    let(:explain_request) do
      described_class.new(name: 'test_index', type: 'some_type', query: 'test')
    end
    subject(:explain_query) { explain_request.perform }

    it 'sends correct request' do
      expect(described_class)
        .to receive(:get)
        .with(explain_request.url, headers: explain_request.headers, body: explain_request.body)

      explain_query
    end
  end
end
