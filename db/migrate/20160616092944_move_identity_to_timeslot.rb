class MoveIdentityToTimeslot < ActiveRecord::Migration
  def up
    create_join_table :identities, :timeslots do |t|
      t.index [:timeslot_id, :identity_id]
    end
    User.all.each do |user|
      schedule = user.schedules.create
      user.schedules.each do |s|
        next if s == schedule
        s.timeslots.each do |ts|
          ts.identities << s.identity
          ts.update schedule: schedule
        end
        s.delete
      end
    end
    remove_reference :schedules, :identity
  end

  def down
    add_reference :schedules, :identity
    User.all.each do |user|
      user.identities.each do |identity|
        user.schedules.find_or_create_by identity_id: identity.id, user_id: user.id
      end
      user.timeslots.each do |ts|
        ts.identities.each do |identity|
          schedule = user.schedules.find_by identity_id: identity.id, user_id: user.id
          schedule.timeslots << ts
        end
      end
      user.schedules.where('identity_id IS NULL').destroy_all
    end
    drop_join_table :identities, :timeslots
  end
end
