# spec/factories/pokemons.rb
FactoryBot.define do
  factory :pokemon do
    pokedex_number { 25 }
    name { "ピカチュウ" }
    image_url { "https://example.com/image.jpg" }
  end
end
