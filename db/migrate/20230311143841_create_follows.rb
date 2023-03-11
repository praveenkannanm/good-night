class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.integer :follower_id, index: true
      t.integer :followee_id, index: true

      t.timestamps
    end
  end
end
