class RemoveSchedules < ActiveRecord::Migration
  def up
    add_reference :timeslots, :user, index: true, foreign_key: true
    Timeslot.all.each do |timeslot|
      timeslot.update user_id: Schedule.find(timeslot.schedule_id).user_id if timeslot.schedule_id
    end
    remove_reference :timeslots, :schedule
    drop_table :schedules
  end

  def down
    create_table :schedules do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.timestamps null: false
    end
    add_reference :timeslots, :schedule, index: true, foreign_key: true
    User.all.each do |user|
      schedule = Schedule.create user: user
      Timeslot.where(user: user).update_all schedule_id: schedule.id
    end
    remove_reference :timeslots, :user
  end
end
