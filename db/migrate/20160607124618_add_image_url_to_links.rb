class AddImageUrlToLinks < ActiveRecord::Migration
  def change
    add_column :links, :image_url, :string
  end
end
