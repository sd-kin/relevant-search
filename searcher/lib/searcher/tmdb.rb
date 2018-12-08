require 'json'

module Searcher
  # Parsing data file from The Movie DataBase
  class TMDB
    # TODO move that to Searcher::Adapters::TMDB::File
    DEFAULT_PATH = File.join(__dir__, '..', '..', 'data', 'tmdb.json').freeze

    attr_reader :file_path

    def initialize(path = DEFAULT_PATH)
      @file_path = path
    end

    def extract
      JSON.parse(File.open(file_path).read)
    end

    def parse_data_for_bulk_index(index = 'tmdb', type = 'movie')
      # TODO move that out to clients
      bulk_movies = ''

      extract.each do |id, film|
        add_cmd = { index: { _index: index, _type: type, _id: id } }
        bulk_movies += JSON.dump(add_cmd) + "\n" + JSON.dump(film) + "\n"
      end

      bulk_movies
    end
  end
end
