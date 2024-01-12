class PokemonFetchJob < ApplicationJob
  queue_as :default

  def perform(pokedex_number_or_name)
    pokemon_data = PokeapiClient.fetch_pokemon(pokedex_number_or_name)
    pokedex_number = pokemon_data["id"]
    pokemon = Pokemon.find_or_initialize_by(pokedex_number: pokedex_number)

    species_url = pokemon_data.dig("species", "url")
    species_data = PokeapiClient.fetch_japanese_name(species_url)
    names = species_data["names"]
    name = names.find { |v| v["language"]["name"] == "ja" }["name"]

    image_urls = [
      pokemon_data.dig("sprites", "other", "home", "front_default"),
      pokemon_data.dig("sprites", "other", "home", "front_shiny"),
      pokemon_data.dig("sprites", "other", "official-artwork", "front_default"),
      pokemon_data.dig("sprites", "other", "official-artwork", "front_shiny")
    ].compact
    image_urls.delete(pokemon.image_url)
    image_url = image_urls.sample

    pokemon.assign_attributes(
      pokedex_number: pokedex_number,
      name: name,
      image_url: image_url
    )
    pokemon.save!
    pokemon
  rescue => e
    Rails.logger.error "Error fetching Pokemon data: #{e.message}"
    Pokemon.new
  end
end
