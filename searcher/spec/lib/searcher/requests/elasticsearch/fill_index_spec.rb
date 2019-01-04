# frozen_string_literal: true

require 'spec_helper'

describe Searcher::Requests::ElasticSearch::FillIndex do
  describe '.new' do
    subject(:fill_index_request) { described_class.new(params) }
    let(:good_movie) { ['123', { title: 'good movie', description: 'really good movie' }] }
    let(:bad_movie) { ['321', { title: 'bad movie', description: 'really bad movie' }] }
    let(:data) { [good_movie, bad_movie] }
    let(:params) { { data: data, name: 'index_name', type: 'index_type' } }

    it 'has json header' do
      expect(fill_index_request.headers).to eq('Content-Type' => 'application/json')
    end

    it 'builds request body' do
      expect(subject.body).to eq <<~REQUEST
        {"index":{"_index":"index_name","_type":"index_type","_id":"123"}}
        {"title":"good movie","description":"really good movie"}
        {"index":{"_index":"index_name","_type":"index_type","_id":"321"}}
        {"title":"bad movie","description":"really bad movie"}
      REQUEST
    end
  end

  describe '#perform' do
    let(:fill_index_request) do
      described_class.new(data: [], name: 'index_name', type: 'index_type')
    end
    subject { fill_index_request.perform }

    it 'sends post request with json heders' do
      expect(described_class)
        .to receive(:post)
        .with('/_bulk', headers: fill_index_request.headers, body: fill_index_request.body)

      subject
    end
  end
end
