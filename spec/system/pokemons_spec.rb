require "rails_helper"

RSpec.describe "ポケモンの登録と交換のフロー", type: :system do
  let(:user) { create(:user) }
  scenario "ポケモン登録→交換→詳細→逃す", js: true do
    visit root_path
    click_link "ログイン"
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_content "こんにちは。#{user.name}さん"
    click_link "登　録"
    fill_in "図鑑番号", with: 25
    click_button "実行"
    expect(page).to have_content "ピカチュウが登録されました"
    click_link "交換"
    click_button "実行"
    expect(page).to have_content "新しいピカチュウに交換されました"
    click_link "ピカチュウの画像"
    # 全てのタブを取得（target="_blank"対応）
    windows = page.driver.browser.window_handles
    # 最後に開いたタブに移動=リンククリックで開いたタブ
    page.driver.browser.switch_to.window(windows.last)
    # 詳細(AR)ページに設置しているボタンを検証
    expect(page).to have_selector "button", text: "✕"
    # 現在表示中のタブ=リンククリックで開いたタブをクローズ
    page.driver.browser.close
    # 元いたタブに戻る
    page.driver.browser.switch_to.window(windows.first)
    click_link "逃す"
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content "ピカチュウを逃しました"
  end
end
