require 'rails_helper'

RSpec.describe Schedule, type: :model do

  describe 'timeslots_on' do

    it 'should split timeslots in groups' do

      s = Schedule.create
      s.timeslots.create day: 1, offset: 900
      s.timeslots.create day: 1, offset: 900
      s.timeslots.create day: 2, offset: 900
      s.timeslots.create day: 3, offset: 900

      expect(s.timeslots_on(1).count).to eq(2)
      expect(s.timeslots_on(2).count).to eq(1)
      expect(s.timeslots_on(3).count).to eq(1)
    end
  end

  describe 'schedule' do

    it 'should schedule' do
      s = Schedule.create user: User.create, identity: Identity.create
      list = List.create
      s.timeslots.create day: 1, offset: 900, list: list
      list.move_to_front Post.create text: "some text"
      s.schedule Time.now, 7
      expect(Update.count).to eq(1)
      expect(Update.first.text).to eq("some text")
      expect(Update.first.scheduled_at.wday).to eq(1)
      expect(Update.first.scheduled_at.hour).to eq(14)
    end

  end

  describe '#order' do

    it 'should ' do
      s = Schedule.create user: User.create, identity: Identity.create
      list = List.create
      s.timeslots.create day: 1, offset: 900, list: list
      s.timeslots.create day: 1, offset: 843, list: list
      first_pos = list.first_position
      list.move_to_front (p1 = Post.create(text: 'text#1'))
      expect(first_pos).to eq(list.first_position + 1)
      first_pos = list.first_position
      last_pos = list.last_position
      list.move_to_front (p2 = Post.create(text: 'text#2'))
      expect(first_pos).to eq(list.first_position + 1)
      expect(last_pos).to eq(list.last_position)
      first_pos = list.first_position
      last_pos = list.last_position
      s.reschedule 2
      expect(list.first_position).to eq(first_pos + 4)
      expect(s.updates.map &:post_id).to eq([p2.id, p1.id, p2.id, p1.id])
      s.remove_scheduled_updates
      expect(Update.count).to eq(0)
      expect(list.first_position).to eq(first_pos)
    end
  end

end
