class CreateTwitterPosts < ActiveRecord::Migration
  def change
    create_table :twitter_posts do |t|
      t.references :asset, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true

      t.column :text, :string

      t.timestamps null: false
    end
  end
end
