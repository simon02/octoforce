class RemoveContentItems < ActiveRecord::Migration
  def change
    remove_reference :updates, :content_item
    drop_table :content_items
    add_reference :updates, :post, index: true, foreign_key: true
    add_reference :updates, :asset, index: true, foreign_key: true
    add_reference :posts, :asset, index: true, foreign_key: true
    add_column :updates, :text, :string
    add_column :posts, :text, :string
    remove_reference :posts, :next
  end
end
