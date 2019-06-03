class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :email
      t.string :display_name

      t.timestamps
    end
  end
end
