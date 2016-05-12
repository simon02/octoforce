class CreateImportedUpdates < ActiveRecord::Migration
  def change
    create_table :imported_updates do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.references :identity

      t.string :text
      t.integer :likes, default: 0
      t.integer :shares, default: 0
      t.integer :comments, default: 0
      t.string :media_url
      t.string :author
      t.string :original

      t.timestamp :published_at

      t.timestamps null: false
    end
  end

end
