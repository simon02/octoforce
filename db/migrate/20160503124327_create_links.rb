class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :post, index: true

      t.string :url
      t.string :title
      t.string :caption
      t.string :description

      t.timestamps null: false
    end

    add_reference :updates, :link, index: true
  end
end
