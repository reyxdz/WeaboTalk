class AddStatusToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :status, :integer, default: 1, null: false

    # Index on status for filtering drafts vs published posts
    add_index :posts, :status

    # Composite index for common query: user's posts by status
    add_index :posts, [ :user_id, :status ]
  end
end
