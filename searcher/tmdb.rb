require 'json'

# Parsing data file from The Movie DataBase
class TMDB
  def self.extract(path = 'tmdb.json')
    file = File.open(path)

    JSON.parse(file.read)
  end

  def self.parse_data_for_bulk_index(index = 'tmdb', type = 'movie')
    bulk_movies = ''

    extract.each do |id, film|
      add_cmd = { index: { _index: index, _type: type, _id: id } }
      bulk_movies += JSON.dump(add_cmd) + "\n" + JSON.dump(film) + "\n"
    end

    bulk_movies
  end
end
