class AddBitlySettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bitly_login, :string
    add_column :users, :bitly_api_key, :string
  end
end
