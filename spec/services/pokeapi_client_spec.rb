require "rails_helper"

RSpec.describe PokeapiClient, type: :service do
  describe ".fetch_pokemon" do
    it "有効な図鑑番号に対してデータを返す" do
      valid_name_or_number = 25

      VCR.use_cassette("pokeapi") do
        response = PokeapiClient.fetch_pokemon(valid_name_or_number)
        expect(response["id"]).to eq(25)
        expect(response["sprites"]["other"]["home"]["front_default"]).to eq("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/25.png")
        expect(response["sprites"]["other"]["home"]["front_shiny"]).to eq("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/25.png")
        expect(response["sprites"]["other"]["official-artwork"]["front_default"]).to eq("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png")
        expect(response["sprites"]["other"]["official-artwork"]["front_shiny"]).to eq("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/25.png")
      end
    end
  end

  describe ".fetch_japanese_name" do
    it "ポケモンの日本語名を返す" do
      species_url = "https://pokeapi.co/api/v2/pokemon-species/25/"

      VCR.use_cassette("pokeapi_species") do
        response = PokeapiClient.fetch_japanese_name(species_url)
        japanese_name = response["names"].find { |name| name["language"]["name"] == "ja" }
        expect(japanese_name["name"]).to eq("ピカチュウ")
      end
    end
  end
end
