class AddShorteningToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shorten_links, :boolean, default: true
  end
end
