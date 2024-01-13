# spec/requests/pokemons_request_spec.rb

require "rails_helper"

RSpec.describe "Pokemons", type: :request do
  describe "GET /pokemons" do
    it "一覧ページを表示すること" do
      get pokemons_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /pokemons/:id" do
    let(:pokemon) { create(:pokemon) }

    it "詳細ページを表示すること" do
      get pokemon_path(pokemon)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /pokemons/new" do
    it "新規作成ページを表示すること" do
      get new_pokemon_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /pokemons/:id/edit" do
    let(:pokemon) { create(:pokemon) }

    it "編集ページを表示すること" do
      get edit_pokemon_path(pokemon)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /pokemons" do
    it "新しいポケモンを作成してリダイレクトすること" do
      expect {
        post pokemons_path, params: { pokemon: { pokedex_number: 1 } }
      }.to change(Pokemon, :count).by(1)

      expect(response).to have_http_status(302)
    end

    it "エラーを処理してリダイレクトすること" do
      expect {
        post pokemons_path, params: { pokemon: { pokedex_number: 0 } }
      }.not_to change(Pokemon, :count)

      expect(response).to have_http_status(302)
    end
  end

  describe "PATCH /pokemons/:id" do
    let(:pokemon) { create(:pokemon) }

    it "既存のポケモンを更新してリダイレクトすること" do
      old_image_url = pokemon.image_url

      expect {
        patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: 1 } }
      }.to change { pokemon.reload.image_url }

      expect(response).to have_http_status(302)
    end

    it "エラーを処理してリダイレクトすること" do
      expect {
        patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: -1 } }
      }.not_to change { Pokemon.find(pokemon.id).image_url }

      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /pokemons/:id" do
    let!(:pokemon) { create(:pokemon) }

    it "ポケモンを削除してリダイレクトすること" do
      expect {
        delete pokemon_path(pokemon)
      }.to change(Pokemon, :count).by(-1)

      expect(response).to have_http_status(302)
    end
  end
end
