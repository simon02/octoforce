class AddPositionColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :position, :integer, index: true
  end
end
