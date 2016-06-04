class PauseShortenLinks < ActiveRecord::Migration
  def up
    change_column_default :users, :shorten_links, false
  end
  def down
    change_column_default :users, :shorten_links, true
  end
end
