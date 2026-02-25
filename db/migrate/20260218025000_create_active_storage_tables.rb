class CreateActiveStorageTables < ActiveRecord::Migration[7.1]
  def change
    create_table :active_storage_blobs do |t|
      t.string :key, null: false
      t.string :filename, null: false
      t.string :content_type
      t.text :metadata
      t.string :service_name, null: false
      t.bigint :byte_size, null: false
      t.string :checksum

      t.timestamps
    end

    add_index :active_storage_blobs, :key, unique: true

    create_table :active_storage_attachments do |t|
      t.string :name, null: false
      t.references :record, null: false, polymorphic: true, index: false
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }

      t.timestamps
    end

    add_index :active_storage_attachments, [ :record_type, :record_id, :name ], name: :index_active_storage_attachments_uniqueness, unique: true
  end
end
