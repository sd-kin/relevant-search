require 'spec_helper'

describe Searcher do
  describe '.root' do
    it 'includes searcher folder' do
      expect(Searcher.root).to include('searcher')
    end

    it 'does not include lib folder' do
      expect(Searcher.root).to_not include('lib')
    end
  end
end
