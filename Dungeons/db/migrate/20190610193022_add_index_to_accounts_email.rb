# frozen_string_literal: true

class AddIndexToAccountsEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :email
  end
end
