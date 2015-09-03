class CreateContentItems < ActiveRecord::Migration
  def change
    create_table :content_items do |t|
      t.references :user, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.string :text

      t.timestamps null: false
    end
  end
end
