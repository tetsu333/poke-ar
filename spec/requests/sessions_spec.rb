require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    context "ログインしていない場合" do
      it "ログインページを表示する" do
        get new_sessions_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }

      before { post create_sessions_path, params: { email: user.email, password: user.password } }

      it "ポケモン一覧ページにリダイレクトする" do
        get new_sessions_path
        expect(response).to redirect_to(pokemons_path)
      end
    end
  end

  describe "POST /create" do
    let!(:user) { FactoryBot.create(:user) }

    context "正しい情報を提供した場合" do
      it "ログインしてポケモン一覧ページにリダイレクトする" do
        post create_sessions_path, params: { email: user.email, password: user.password }
        expect(response).to redirect_to(pokemons_path)
      end
    end

    context "誤った情報を提供した場合" do
      it "ログインページにリダイレクトする" do
        post create_sessions_path, params: { email: user.email, password: "wrong_password" }
        expect(response).to redirect_to(new_sessions_path)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { FactoryBot.create(:user) }

    before { post create_sessions_path, params: { email: user.email, password: user.password } }

    it "ログアウトしてログインページにリダイレクトする" do
      delete destroy_sessions_path(user)
      expect(response).to redirect_to(new_sessions_path)
    end
  end
end
