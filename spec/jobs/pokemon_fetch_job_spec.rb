# spec/jobs/pokemon_fetch_job_spec.rb
require "rails_helper"

RSpec.describe PokemonFetchJob, type: :job do
  describe "#perform" do
    context "ポケモンのデータが正しく取得できる場合" do
      it "ポケモンをデータベースに保存する" do
        pokedex_number_or_name = 25

        VCR.use_cassette("pokeapi") do
          expect {
            PokemonFetchJob.perform_now(pokedex_number_or_name)
          }.to change(Pokemon, :count).by(1)
        end

        pokemon = Pokemon.last
        expect(pokemon.name).to eq("ピカチュウ")
        expect(pokemon.pokedex_number).to eq(25)
        expect(pokemon.image_url).to include("https://raw.githubusercontent.com")
      end
    end

    context "エラーが発生した場合" do
      it "エラーログを出力する" do
        invalid_pokedex_number_or_name = 99999

        VCR.use_cassette("pokeapi") do
          expect(Rails.logger).to receive(:error).with(/Error fetching Pokemon data/)
          expect {
            PokemonFetchJob.perform_now(invalid_pokedex_number_or_name)
          }.not_to change(Pokemon, :count)
        end
      end
    end
  end
end
