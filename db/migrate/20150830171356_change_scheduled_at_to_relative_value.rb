class ChangeScheduledAtToRelativeValue < ActiveRecord::Migration
  def change
    add_column :timeslots, :offset, :integer
    remove_column :timeslots, :scheduled_at, :string
  end
end
