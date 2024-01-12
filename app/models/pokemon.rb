class Pokemon < ApplicationRecord
  validates :pokedex_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :image_url, presence: true, length: { maximum: 255 }, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
