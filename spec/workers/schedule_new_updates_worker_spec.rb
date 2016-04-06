require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ScheduleNewUpdatesWorker, type: :worker do

  describe '#perform' do
    it 'should perform' do
      user = User.create(timezone: 'Europe/Brussels')
      schedule = user.schedules.create
      category = user.categories.create
      category.posts.create text: 'sample post 1'
      category.posts.create text: 'sample post 2'
      schedule.timeslots.create offset: 600, day: 1, category: category
      schedule.timeslots.create offset: 630, day: 1, category: category
      schedule.timeslots.create offset: 600, day: 2, category: category
      expect(category.updates.scheduled.count).to eq 0
      Sidekiq::Testing.inline! do
        ScheduleNewUpdatesWorker.perform_async
        expect(category.updates.scheduled.count).to eq 6
        # runnign the same thing twice, shouldn't add anything
        ScheduleNewUpdatesWorker.perform_async
        expect(category.updates.scheduled.count).to eq 6
        category.updates.scheduled.sorted.last.destroy
        # removing the last one, should add it
        expect(category.updates.scheduled.count).to eq 5
        ScheduleNewUpdatesWorker.perform_async
        expect(category.updates.scheduled.count).to eq 6
      end
    end
  end

end
