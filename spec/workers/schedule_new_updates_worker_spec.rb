require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe UrlWorker, type: :worker do

  describe '#perform' do
    it 'should perform' do
      user = User.create(timezone: 'Europe/Brussels')
      schedule = user.schedules.create
      list = user.lists.create
      list.posts.create text: 'sample post 1'
      list.posts.create text: 'sample post 2'
      schedule.timeslots.create offset: 600, day: 1, list: list
      schedule.timeslots.create offset: 630, day: 1, list: list
      schedule.timeslots.create offset: 600, day: 2, list: list
      expect(list.updates.scheduled.count).to eq 0
      Sidekiq::Testing.inline! do
        ScheduleNewUpdatesWorker.perform_async
        expect(list.updates.scheduled.count).to eq 6
        # runnign the same thing twice, shouldn't add anything
        ScheduleNewUpdatesWorker.perform_async
        expect(list.updates.scheduled.count).to eq 6
        list.updates.scheduled.sorted.last.destroy
        # removing the last one, should add it
        expect(list.updates.scheduled.count).to eq 5
        ScheduleNewUpdatesWorker.perform_async
        expect(list.updates.scheduled.count).to eq 6
      end
    end
  end

end
