require 'rails_helper'

RSpec.describe Schedule, type: :model do

  describe 'timeslots_on' do

    it 'should split timeslots in groups' do

      s = Schedule.create
      s.timeslots.create day: 1, scheduled_at: Time.now
      s.timeslots.create day: 1, scheduled_at: Time.now
      s.timeslots.create day: 2, scheduled_at: Time.now
      s.timeslots.create day: 3, scheduled_at: Time.now

      expect(s.timeslots_on(1).count).to eq(2)
      expect(s.timeslots_on(2).count).to eq(1)
      expect(s.timeslots_on(3).count).to eq(1)
    end
  end

  describe 'schedule' do

    it 'should schedule' do
      s = Schedule.create
      slot = Timeslot.create day: 1, scheduled_at: Time.parse("9am")
      list = List.create
      list.add_to_front Post.create content_items: [ContentItem.create(text: "some text")]
      slot.list = list
      s.timeslots << slot
      s.schedule Time.now, 7
      expect(Update.count).to eq(1)
      expect(Update.first.content_item.text).to eq("some text")
      expect(Update.first.scheduled_at).to eq(Time.now)
    end

  end

end
