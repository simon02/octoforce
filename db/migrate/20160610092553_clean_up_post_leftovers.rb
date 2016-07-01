class CleanUpPostLeftovers < ActiveRecord::Migration
  def change
    remove_column :posts, :last_scheduled, :datetime
    remove_column :posts, :position, :integer

    # move link reference to post instead of other way
    remove_reference :links, :post
    add_reference :posts, :link
  end
end
