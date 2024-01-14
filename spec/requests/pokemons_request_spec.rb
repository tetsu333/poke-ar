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
    context "登録済みポケモンのpokedex_numberな場合" do
      let!(:pokemon) { create(:pokemon) }
  
      it "ポケモンを登録せずにリダイレクトすること" do
        VCR.use_cassette("pokeapi") do
          expect {
            post pokemons_path, params: { pokemon: { pokedex_number: pokemon.pokedex_number } }
          }.not_to change(Pokemon, :count)
    
          expect(response).to have_http_status(302)
        end
      end
    end
  
    context "未登録ポケモンのpokedex_numberな場合" do
      it "新しいポケモンを登録してリダイレクトすること" do
        VCR.use_cassette("pokeapi") do
          expect {
            post pokemons_path, params: { pokemon: { pokedex_number: 25 } }
          }.to change(Pokemon, :count).by(1)
    
          expect(response).to have_http_status(302)
        end
      end
    end
  
    context "エラーが発生する場合" do
      it "ポケモンを登録せずにリダイレクトすること" do
        VCR.use_cassette("pokeapi") do
          expect {
            post pokemons_path, params: { pokemon: { pokedex_number: 0 } }
          }.not_to change(Pokemon, :count)
      
          expect(response).to have_http_status(302)
        end
      end
    end
  end   

  describe "PATCH /pokemons/:id" do
    let!(:pokemon) { create(:pokemon) }

    context "登録済みポケモンを更新する場合" do
      it "image_urlを更新してリダイレクトすること" do
        old_image_url = pokemon.image_url
        old_name = pokemon.name
        old_pokedex_number = pokemon.pokedex_number

        VCR.use_cassette("pokeapi") do
          expect {
            patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: 25 } }
          }.to change { pokemon.reload.image_url }

          expect(pokemon.reload.name).to eq(old_name)
          expect(pokemon.reload.pokedex_number).to eq(old_pokedex_number)
          expect(response).to have_http_status(302)
        end
      end
    end

    context "エラーが発生する場合" do
      it "更新せずにリダイレクトすること" do
        VCR.use_cassette("pokeapi") do
          expect {
            patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: -1 } }
          }.not_to change { Pokemon.find(pokemon.id).attributes }

          expect(response).to have_http_status(302)
        end
      end
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
