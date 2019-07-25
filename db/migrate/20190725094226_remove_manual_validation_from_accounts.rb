class RemoveManualValidationFromAccounts < ActiveRecord::Migration[5.2]
  def change
    #remove_column :microposts, :picture, :string
    remove_column :accounts, :remember_digest, :string
    remove_column :accounts, :activation_digest, :string
    remove_column :accounts, :activated, :boolean, default: false
    remove_column :accounts, :activated_at, :datetime
    remove_column :accounts, :reset_digest, :string
    remove_column :accounts, :reset_sent_at, :datetime
  end
end
