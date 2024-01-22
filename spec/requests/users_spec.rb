require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "ユーザー作成ページを表示する" do
      get new_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    context "有効な情報の場合" do
      let(:user_params) { { user: { name: "テストユーザー", email: "user@example.com", password: "password1234", password_confirmation: "password1234" } } }

      it "ユーザーが作成され、ポケモン一覧ページにリダイレクトする" do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(pokemons_path)
      end
    end

    context "無効な情報の場合" do
      let(:invalid_user_params) { { user: { name: "", email: "userexample.com", password: "password", password_confirmation: "password" } } }

      it "ユーザーが作成されず、ユーザー作成ページが再描画される" do
        expect {
          post users_path, params: invalid_user_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
