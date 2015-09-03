class AddLastScheduledToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_scheduled, :datetime
  end
end
