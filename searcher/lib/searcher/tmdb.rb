# frozen_string_literal: true

require 'json'

module Searcher
  # Parsing data file from The Movie DataBase
  class TMDB
    DEFAULT_PATH = File.join(__dir__, '..', '..', 'data', 'tmdb.json').freeze

    attr_reader :file_path

    def initialize(path = DEFAULT_PATH)
      @file_path = path
    end

    def extract
      JSON.parse(File.open(file_path).read)
    end
  end
end
