require 'rails_helper'

RSpec.describe Timeslot, type: :model do

  it "should calculate a correct scheduling time" do
    schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
    slot = Timeslot.create day: 4, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
    time = slot.calculate_scheduling_time 2015, 35
    expect(time.to_time).to eq(Time.new(2015, 8, 27, 7, 32, 0, 0))
  end

end
