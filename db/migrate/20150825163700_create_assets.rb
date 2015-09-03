class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.attachment :media

      t.timestamps null: false
    end

    add_reference :content_items, :asset, index: true, foreign_key: true
  end
end
