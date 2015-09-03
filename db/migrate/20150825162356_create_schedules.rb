class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :identity, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
