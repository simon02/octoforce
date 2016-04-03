require 'rails_helper'

RSpec.describe List, type: :model do

  describe 'move_to_front' do
    it 'should be able to handle empty lists' do
      list = List.new
      post = Post.new
      list.move_to_front post
      expect(list.posts.sorted.first).to eq(post)
    end

    it 'should be able to handle a list with a single item' do
      list = List.new
      p1 = Post.new
      p2 = Post.new
      list.move_to_front p1
      list.move_to_front p2
      expect(list.posts.sorted.first).to eq(p2)
      expect(list.posts.sorted.last).to eq(p1)
    end
  end

  describe 'move_to_back' do

    it 'should be able to handle empty lists' do
      list = List.new
      post = Post.new
      list.move_to_back post
      expect(list.posts.sorted.first).to eq(post)
    end

    it 'should be able to handle non-empty lists' do
      list = List.new
      p1 = Post.new
      p2 = Post.new
      list.move_to_back p1
      list.move_to_back p2
      expect(list.posts.sorted.first).to eq(p1)
      expect(list.posts.sorted.last).to eq(p2)
      expect(list.posts.count).to eq 2
    end
  end

  describe '#sorted_posts' do

    it 'should prioritize posts with scheduled updates' do
    end

  end

  describe '#schedule_between' do

    it 'does not schedule anything if no timeslots match the times' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      list = List.create
      # 10am
      schedule.timeslots.create offset: 600, day: 1, list: list
      schedule.timeslots.create offset: 600, day: 2, list: list
      start = Date.commercial(2016,4,3).to_time + 9.hours
      end_t = Date.commercial(2016,4,3).to_time + 12.hours
      list.schedule_between start, end_t
      expect(list.updates.count).to eq 0
    end

    it 'works with a basic example' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      list = List.create
      list.posts.create text: 'sample post 1'
      list.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, list: list
      schedule.timeslots.create offset: 630, day: 1, list: list
      schedule.timeslots.create offset: 600, day: 2, list: list
      start = Date.commercial(2016,4,1).to_time
      end_t = Date.commercial(2016,4,2).to_time - 1
      list.schedule_between start, end_t
      expect(list.updates.count).to eq 2
      expect(list.updates.sorted.first.scheduled_at).to eq(Date.commercial(2016,4,1).to_time + 10.hours)
      expect(list.updates.sorted.last.scheduled_at).to eq(Date.commercial(2016,4,1).to_time + 10.hours + 30.minutes)
    end

    it 'works with multiple weeks' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      list = List.create
      list.posts.create text: 'sample post 1'
      list.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, list: list
      schedule.timeslots.create offset: 600, day: 2, list: list
      start = Date.commercial(2016,4,1).to_time
      end_t = Date.commercial(2016,7,1).to_time - 1
      list.schedule_between start, end_t
      expect(list.updates.count).to eq 6
    end

    it 'should also work when start_time is an edge case' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      list = List.create
      list.posts.create text: 'sample post 1'
      list.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, list: list
      schedule.timeslots.create offset: 600, day: 2, list: list
      start = Date.commercial(2016,4,1).to_time + 10.hours
      end_t = Date.commercial(2016,4,1).to_time + 11.hours
      list.schedule_between start, end_t
      expect(list.updates.count).to eq 1
    end

    it 'should also work when end_time is an edge case' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      list = List.create
      list.posts.create text: 'sample post 1'
      list.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, list: list
      schedule.timeslots.create offset: 600, day: 2, list: list
      start = Date.commercial(2016,4,1).to_time
      end_t = Date.commercial(2016,4,1).to_time + 10.hours
      list.schedule_between start, end_t
      expect(list.updates.count).to eq 1
    end

  end

end
