# frozen_string_literal: true
class AddPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :token, :string
    add_index :users, :token, unique: true
  end
end
