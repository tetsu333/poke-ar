# spec/factories/pokemons.rb
FactoryBot.define do
  factory :pokemon do
    pokedex_number { 1 }
    name { "フシギダネ" }
    image_url { "https://example.com/image.jpg" }
  end
end
