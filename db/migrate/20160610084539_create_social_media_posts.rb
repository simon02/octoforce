class CreateSocialMediaPosts < ActiveRecord::Migration
  def change
    create_table :social_media_posts do |t|
      t.references :post, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.references :asset
      t.references :link

      t.text :text
      t.integer :position

      t.timestamps null: false
    end
  end
end
