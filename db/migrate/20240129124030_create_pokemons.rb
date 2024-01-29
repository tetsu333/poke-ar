class CreatePokemons < ActiveRecord::Migration[7.1]
  def change
    create_table :pokemons do |t|
      t.integer :pokedex_number, null: false
      t.string :name, null: false
      t.string :image_url, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :pokemons, [:pokedex_number, :user_id], unique: true
  end
end
