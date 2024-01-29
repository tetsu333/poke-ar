require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:pokemons) }
  end

  describe "validations" do
    subject { User.new(name: "テストユーザー", email: "test@example.com", password: "password1234") }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value("user@example.com").for(:email) }
    it { is_expected.not_to allow_value("invalid_email").for(:email) }

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to allow_value("abc123").for(:password) }
    it { is_expected.not_to allow_value("abcdef").for(:password) }
    it { is_expected.not_to allow_value("123456").for(:password) }
  end

  describe "downcase_email" do
    it "保存前にメールアドレスを小文字に変換すること" do
      user = User.create(name: "テストユーザー", email: "TEST@EXAMPLE.COM", password: "password1234")
      expect(user.email).to eq("test@example.com")
    end
  end
end
