class AddJobIdToUpdate < ActiveRecord::Migration
  def change
    add_column :updates, :jid, :string
  end
end
