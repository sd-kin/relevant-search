# frozen_string_literal: true

require 'spec_helper'

describe Searcher::Requests::ElasticSearch::DeleteIndex do
  describe '.new' do
    context 'when called without arguments' do
      it 'has default index name' do
        expect(described_class.new.index_name).to eq 'tmdb'
      end
    end

    context 'when called with index name' do
      it 'has given index name' do
        expect(described_class.new(name: 'another_index').index_name)
          .to eq('another_index')
      end
    end
  end

  describe '#call' do
    it 'sends delete request with index name' do
      expect(described_class).to receive(:delete).with('/tmdb')
      described_class.new.perform
    end
  end
end
