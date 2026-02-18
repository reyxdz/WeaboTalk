class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username, null: false, unique: true
      t.text :bio, limit: 500
      t.integer :followers_count, default: 0
      t.integer :following_count, default: 0

      t.timestamps
    end

    add_index :profiles, :username, unique: true
  end
end
