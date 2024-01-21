# spec/requests/pokemons_request_spec.rb

require "rails_helper"

RSpec.describe "Pokemons", type: :request do
  describe "GET /pokemons" do
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        get pokemons_path
        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      it "ポケモン一覧ページを表示する" do
        get pokemons_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /pokemons/:id" do
    let(:pokemon) { create(:pokemon) }
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        get pokemon_path(pokemon)
        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      it "詳細ページを表示する" do
        get pokemon_path(pokemon)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /pokemons/new" do
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        get new_pokemon_path
        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      it "新規作成ページを表示する" do
        get new_pokemon_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /pokemons/:id/edit" do
    let(:pokemon) { create(:pokemon) }

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        get edit_pokemon_path(pokemon)
        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      it "編集ページを表示する" do
        get edit_pokemon_path(pokemon)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /pokemons" do
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        post pokemons_path, params: { pokemon: { pokedex_number: 25 } }

        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      context "登録済みポケモンのpokedex_numberな場合" do
        let!(:pokemon) { create(:pokemon) }
        it "登録せずに登録ページを表示する" do
          VCR.use_cassette("pokeapi") do
            expect {
              post pokemons_path, params: { pokemon: { pokedex_number: pokemon.pokedex_number } }
            }.not_to change(Pokemon, :count)
  
            expect(response).to redirect_to(new_pokemon_path)
          end
        end
      end
    
      context "未登録ポケモンのpokedex_numberな場合" do
        let!(:pokemon) { create(:pokemon, name: "フシギダネ", pokedex_number: 1) }
        it "登録して一覧ページを表示する" do
          VCR.use_cassette("pokeapi") do
            expect {
              post pokemons_path, params: { pokemon: { pokedex_number: 25 } }
            }.to change(Pokemon, :count).by(1)
  
            expect(response).to redirect_to(pokemons_path)
          end
        end
      end
    
      context "存在しないポケモン図鑑番号な場合" do
        it "登録せずに登録ページを表示する" do
          VCR.use_cassette("pokeapi") do
            expect {
              post pokemons_path, params: { pokemon: { pokedex_number: 0 } }
            }.not_to change(Pokemon, :count)
        
            expect(response).to redirect_to(new_pokemon_path)
          end
        end
      end
    end
  end   

  describe "PATCH /pokemons/:id" do
    let!(:pokemon) { create(:pokemon) }

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: 25 } }

        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      context "登録済みポケモンを更新する場合" do
        it "image_urlを更新して一覧ページを表示する" do
          old_image_url = pokemon.image_url
          old_name = pokemon.name
          old_pokedex_number = pokemon.pokedex_number
  
          VCR.use_cassette("pokeapi") do
            expect {
              patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: old_pokedex_number } }
            }.to change { pokemon.reload.image_url }
  
            expect(pokemon.reload.name).to eq(old_name)
            expect(pokemon.reload.pokedex_number).to eq(old_pokedex_number)
            expect(response).to redirect_to(pokemons_path)
          end
        end
      end

      context "存在しないポケモン図鑑番号な場合" do
        it "更新せずに一覧ページを表示する" do
          VCR.use_cassette("pokeapi") do
            expect {
              patch pokemon_path(pokemon), params: { pokemon: { pokedex_number: 99999 } }
            }.not_to change { pokemon.reload.image_url }
  
            expect(response).to redirect_to(pokemons_path)
          end
        end
      end
    end
  end

  describe "DELETE /pokemons/:id" do
    let!(:pokemon) { create(:pokemon) }

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        delete pokemon_path(pokemon)
        expect(response).to redirect_to(new_sessions_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      it "ポケモンを削除して一覧ページを表示する" do
        expect {
          delete pokemon_path(pokemon)
        }.to change(Pokemon, :count).by(-1)
  
        expect(response).to redirect_to(pokemons_path)
      end
    end
  end
end
