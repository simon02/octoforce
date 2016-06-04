class CreateFacebookPosts < ActiveRecord::Migration
  def change
    create_table :facebook_posts do |t|
      t.references :asset, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.references :link

      t.column :text, :string
      t.string :url
      t.string :title
      t.string :caption
      t.string :description

      t.timestamps null: false
    end
  end
end
