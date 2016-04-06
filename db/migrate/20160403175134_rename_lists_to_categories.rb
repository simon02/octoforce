class RenameListsToCategories < ActiveRecord::Migration
  def change
    rename_table :lists, :categories
    rename_column :updates, :list_id, :category_id
    rename_column :posts, :list_id, :category_id
    rename_column :timeslots, :list_id, :category_id
    rename_column :feeds, :list_id, :category_id
  end
end
