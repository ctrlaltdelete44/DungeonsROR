# frozen_string_literal: true

class RemoveImageFromMicroposts < ActiveRecord::Migration[5.2]
  def change
    remove_column :microposts, :picture, :string
  end
end
