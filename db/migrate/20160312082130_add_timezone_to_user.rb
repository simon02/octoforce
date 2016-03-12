class AddTimezoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string, default: "Europe/Brussels"
  end
end
