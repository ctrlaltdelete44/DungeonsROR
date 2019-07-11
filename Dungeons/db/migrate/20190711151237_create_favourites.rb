class CreateFavourites < ActiveRecord::Migration[5.2]
  def change
    create_table :favourites do |t|
      t.integer :account_id
      t.integer :micropost_id

      t.timestamps
    end
    add_index :favourites, :account_id
    add_index :relationships, :micropost_id
  end
end
