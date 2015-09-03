class AddListRefToUpdates < ActiveRecord::Migration
  def change
    add_reference :updates, :list, index: true, foreign_key: true
  end
end
