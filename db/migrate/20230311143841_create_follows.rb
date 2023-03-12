# frozen_string_literal: true
class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.integer :follower_id, index: true, null: false
      t.integer :followee_id, index: true, null: false

      t.timestamps
    end
  end
end
