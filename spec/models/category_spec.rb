require 'rails_helper'

RSpec.describe Category, type: :model do

  describe 'move_to_front' do
    it 'should be able to handle empty categories' do
      category = Category.new
      post = Post.new
      category.move_to_front post
      expect(category.posts.sorted.first).to eq(post)
    end

    it 'should be able to handle a category with a single item' do
      category = Category.new
      p1 = Post.new
      p2 = Post.new
      category.move_to_front p1
      category.move_to_front p2
      expect(category.posts.sorted.first).to eq(p2)
      expect(category.posts.sorted.last).to eq(p1)
    end
  end

  describe 'move_to_back' do

    it 'should be able to handle empty categories' do
      category = Category.new
      post = Post.new
      category.move_to_back post
      expect(category.posts.sorted.first).to eq(post)
    end

    it 'should be able to handle non-empty categories' do
      category = Category.new
      p1 = Post.new
      p2 = Post.new
      category.move_to_back p1
      category.move_to_back p2
      expect(category.posts.sorted.first).to eq(p1)
      expect(category.posts.sorted.last).to eq(p2)
      expect(category.posts.count).to eq 2
    end
  end

  describe '#sorted_posts' do

    it 'should prioritize posts with scheduled updates' do
    end

  end

  describe '#schedule_between' do

    it 'does not schedule anything if no timeslots match the times' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      category = Category.create
      # 10am
      schedule.timeslots.create offset: 600, day: 1, category: category
      schedule.timeslots.create offset: 600, day: 2, category: category
      start = Date.commercial(2016,4,3).to_time + 9.hours
      end_t = Date.commercial(2016,4,3).to_time + 12.hours
      category.schedule_between start, end_t
      expect(category.updates.count).to eq 0
    end

    it 'works with a basic example' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      category = Category.create
      category.posts.create text: 'sample post 1'
      category.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, category: category
      schedule.timeslots.create offset: 630, day: 1, category: category
      schedule.timeslots.create offset: 600, day: 2, category: category
      start = Date.commercial(2016,4,1).to_time
      end_t = Date.commercial(2016,4,2).to_time - 1
      category.schedule_between start, end_t
      expect(category.updates.count).to eq 2
      expect(category.updates.sorted.first.scheduled_at).to eq(Date.commercial(2016,4,1).to_time + 10.hours)
      expect(category.updates.sorted.last.scheduled_at).to eq(Date.commercial(2016,4,1).to_time + 10.hours + 30.minutes)
    end

    it 'works with multiple weeks' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      category = Category.create
      category.posts.create text: 'sample post 1'
      category.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, category: category
      schedule.timeslots.create offset: 600, day: 2, category: category
      start = Date.commercial(2016,4,1).to_time
      end_t = Date.commercial(2016,7,1).to_time - 1
      category.schedule_between start, end_t
      expect(category.updates.count).to eq 6
    end

    it 'should also work when start_time is an edge case' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      category = Category.create
      category.posts.create text: 'sample post 1'
      category.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, category: category
      schedule.timeslots.create offset: 600, day: 2, category: category
      start = Date.commercial(2016,4,1).to_time + 10.hours
      end_t = Date.commercial(2016,4,1).to_time + 11.hours
      category.schedule_between start, end_t
      expect(category.updates.count).to eq 1
    end

    it 'should also work when end_time is an edge case' do
      schedule = Schedule.create user: User.new(timezone: 'Europe/Brussels')
      category = Category.create
      category.posts.create text: 'sample post 1'
      category.posts.create text: 'sample post 2'
      # 10am
      schedule.timeslots.create offset: 600, day: 1, category: category
      schedule.timeslots.create offset: 600, day: 2, category: category
      start = Date.commercial(2016,4,1).to_time
      end_t = Date.commercial(2016,4,1).to_time + 10.hours
      category.schedule_between start, end_t
      expect(category.updates.count).to eq 1
    end

  end

end
