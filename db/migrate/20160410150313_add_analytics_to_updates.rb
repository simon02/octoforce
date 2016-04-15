class AddAnalyticsToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :likes, :integer, default: 0
    add_column :updates, :shares, :integer, default: 0
    add_column :updates, :comments, :integer, default: 0
    add_column :updates, :response_id, :string, index: true
    add_column :updates, :published_at, :timestamp

    reversible do |change|
      change.up do
        Update.published.update_all("published_at=updated_at")
      end
    end
  end

end
