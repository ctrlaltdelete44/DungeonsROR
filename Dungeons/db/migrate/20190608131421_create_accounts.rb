# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :display_name
      t.string :email

      t.timestamps
    end
  end
end
