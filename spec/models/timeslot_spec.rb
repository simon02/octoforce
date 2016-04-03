require 'rails_helper'

RSpec.describe Timeslot, type: :model do

  it "should calculate a correct scheduling time" do
    schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
    slot = Timeslot.create day: 4, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
    time = slot.calculate_scheduling_time 2015, 35
    expect(time.to_time).to eq(Time.new(2015, 8, 27, 7, 32, 0, 0))
  end

  describe '#create_with_timestamp' do

    it 'should create a timeslot object' do
      slot = Timeslot.create_with_timestamp offset: "9:03am", day: 1
      expect(slot.offset).to eq 543
    end

  end

  describe '#calculate_scheduling_time_between' do

    it 'should return nil if timeslot is before start_time' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      timeslot = Timeslot.create day: 3, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
      # date commercial uses local timezone..
      start_time = Date.commercial(2016, 4, 3).to_time + 9.hours + 32.minutes + 1.second
      end_time = Date.commercial(2016, 4, 5).to_time
      result = timeslot.calculate_scheduling_time_between start_time, end_time
      expect(result).to eq(nil)
    end

    it 'should return nil if timeslot is after end_time' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      timeslot = Timeslot.create day: 3, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
      # date commercial uses local timezone..
      start_time = Date.commercial(2016, 4, 1).to_time
      end_time = Date.commercial(2016, 4, 3).to_time + 9.hours + 31.minutes + 59.seconds
      result = timeslot.calculate_scheduling_time_between start_time, end_time
      expect(result).to eq(nil)
    end

    it 'should work if start_time is the expected result' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      timeslot = Timeslot.create day: 3, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
      # date commercial uses local timezone..
      start_time = Date.commercial(2016, 4, 3).to_time + 9.hours + 32.minutes
      end_time = Date.commercial(2016, 4, 5).to_time
      result = timeslot.calculate_scheduling_time_between start_time, end_time
      expect(result).to eq(start_time)
    end

    it 'should work if it is somewhere in between' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      timeslot = Timeslot.create day: 3, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
      # date commercial uses local timezone..
      start_time = Date.commercial(2016, 4, 1).to_time
      end_time = Date.commercial(2016, 4, 5).to_time + 9.hours
      result = timeslot.calculate_scheduling_time_between start_time, end_time
      expect(result).to eq(Date.commercial(2016,4,3).to_time + 9.hours + 32.minutes)
    end

    it 'should return the first time if there are multiple possible' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      timeslot = Timeslot.create day: 3, offset: (9.hours + 32.minutes).to_i / 60, schedule: schedule
      # date commercial uses local timezone..
      start_time = Date.commercial(2016, 4, 1).to_time
      end_time = Date.commercial(2016, 10, 5).to_time
      result = timeslot.calculate_scheduling_time_between start_time, end_time
      expect(result).to eq(Date.commercial(2016,4,3).to_time + 9.hours + 32.minutes)
    end

  end

end
