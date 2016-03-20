class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :list, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :url, index: true
      t.string :status
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
