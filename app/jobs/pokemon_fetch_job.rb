class PokemonFetchJob < ApplicationJob
  queue_as :default

  def perform(pokedex_number_or_name, user_id)
    pokemon_data = fetch_pokemon_data(pokedex_number_or_name)
    save_pokemon(pokemon_data, user_id)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def fetch_pokemon_data(pokedex_number_or_name)
    PokeapiClient.fetch_pokemon(pokedex_number_or_name)
  end

  def save_pokemon(pokemon_data, user_id)
    pokedex_number = pokemon_data["id"]
    pokemon = Pokemon.find_or_initialize_by(pokedex_number: pokedex_number, user_id: user_id)
    name = fetch_japanese_name(pokemon_data.dig("species", "url"))
    image_url = select_image_url(pokemon_data, pokemon.image_url)
    pokemon.assign_attributes(pokedex_number: pokedex_number, name: name, image_url: image_url, user_id: user_id)
    pokemon.save!
    pokemon
  end

  def fetch_japanese_name(species_url)
    species_data = PokeapiClient.fetch_japanese_name(species_url)
    species_data["names"].find { |v| v["language"]["name"] == "ja" }["name"]
  end

  def select_image_url(pokemon_data, current_image_url)
    image_urls = [
      pokemon_data.dig("sprites", "other", "home", "front_default"),
      pokemon_data.dig("sprites", "other", "home", "front_shiny"),
      pokemon_data.dig("sprites", "other", "official-artwork", "front_default"),
      pokemon_data.dig("sprites", "other", "official-artwork", "front_shiny")
    ].compact
    image_urls.delete(current_image_url)
    image_urls.sample
  end

  def handle_error(e)
    Rails.logger.error "Error fetching Pokemon data: #{e.message}"
    error_message = e.message.include?("Not Found") ? "見つかりませんでした" : "予期しないエラーが発生しました"
    [Pokemon.new, error_message]
  end
end
