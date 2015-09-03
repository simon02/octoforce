class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.references :content_item, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :timeslot, index: true, foreign_key: true
      t.timestamp :scheduled_at
      t.boolean :published, default: false

      t.timestamps null: false
    end
  end
end
