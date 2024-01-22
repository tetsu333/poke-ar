require "rails_helper"

RSpec.describe Pokemon, type: :model do
  describe "validations" do
    let(:user) { FactoryBot.create(:user) }
    subject { Pokemon.new(pokedex_number: 1, name: "フシギダネ", image_url: "https://example.com/image.jpg", user_id: user.id) }

    it { is_expected.to validate_presence_of(:pokedex_number) }
    it { is_expected.to validate_uniqueness_of(:pokedex_number) }
    it { is_expected.to validate_numericality_of(:pokedex_number).only_integer.is_greater_than_or_equal_to(1) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }

    it { is_expected.to validate_presence_of(:image_url) }
    it { is_expected.to validate_length_of(:image_url).is_at_most(255) }
    it { is_expected.to allow_value("https://example.com/image.jpg").for(:image_url) }
    it { is_expected.not_to allow_value("invalid_url").for(:image_url) }
  end
end

