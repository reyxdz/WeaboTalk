class CreateReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.string :reaction_type, null: false

      t.timestamps
    end

    add_index :reactions, [ :user_id, :post_id, :reaction_type ], unique: true
  end
end
