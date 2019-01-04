# frozen_string_literal: true

require 'spec_helper'
require_relative File.join(Searcher.root, 'lib', 'searcher', 'tmdb.rb')

describe Searcher::TMDB do
  describe '#new' do
    context 'when initialized without file path' do
      it 'has default file path' do
        expect(Searcher::TMDB.new.file_path).to eq Searcher::TMDB::DEFAULT_PATH
      end
    end

    context 'when initialized with a file path' do
      it 'has file path initialized with' do
        expect(Searcher::TMDB.new('test.json').file_path).to eq 'test.json'
      end
    end
  end

  describe '#extract' do
    let(:path_to_fixture) do
      File.join(Searcher.root, 'spec', 'fixtures', 'tmdb_example.json')
    end

    it 'opens file with given path' do
      expect(File).to receive(:open)
        .with(Searcher::TMDB::DEFAULT_PATH)
        .and_call_original

      Searcher::TMDB.new.extract
    end

    it 'parses JSON from file' do
      expect(Searcher::TMDB.new(path_to_fixture).extract.fetch('93837'))
        .to_not be_nil
    end
  end
end
