class CreateTimeslots < ActiveRecord::Migration
  def change
    create_table :timeslots do |t|
      t.references :list, index: true, foreign_key: true
      t.references :schedule, index: true, foreign_key: true
      t.integer :day
      t.time :scheduled_at

      t.timestamps null: false
    end
  end
end
