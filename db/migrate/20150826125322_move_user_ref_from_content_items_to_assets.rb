class MoveUserRefFromContentItemsToAssets < ActiveRecord::Migration
  def change
    add_reference :assets, :user, index: true, foreign_key: true
    remove_reference :content_items, :user
  end
end
