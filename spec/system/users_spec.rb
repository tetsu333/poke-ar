require "rails_helper"

RSpec.describe "ユーザー認証プロセス", type: :system do
  scenario "ユーザー作成→ログアウト→ログイン" do
    visit root_path
    click_link "新規登録"
    fill_in "名前", with: "サトシ"
    fill_in "Eメール", with: "satoshi@poke.ar"
    fill_in "パスワード", with: "pikachu25"
    fill_in "パスワード確認", with: "pikachu25"
    click_button "作成"
    expect(page).to have_content "ようこそ。サトシさん"
    click_link "HOME"
    click_link "ログアウト"
    fill_in "Eメール", with: "satoshi@poke.ar"
    fill_in "パスワード", with: "pikachu25"
    click_button "ログイン"
    expect(page).to have_content "こんにちは。サトシさん"
  end
end
