require "net/http"

class PokeapiClient
  BASE_URL = "https://pokeapi.co/api/v2/pokemon/"

  def self.fetch_pokemon(pokedex_number_or_name)
    url = "#{BASE_URL}#{pokedex_number_or_name}"
    response = Net::HTTP.get(URI(url))
    JSON.parse(response)
  end

  def self.fetch_japanese_name(species_url)
    response = Net::HTTP.get(URI(species_url))
    JSON.parse(response)
  end
end
