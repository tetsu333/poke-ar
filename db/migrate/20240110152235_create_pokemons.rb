class CreatePokemons < ActiveRecord::Migration[7.1]
  def change
    create_table :pokemons do |t|
      t.integer :pokedex_number
      t.string :name
      t.string :image_url

      t.timestamps
    end
  end
end
