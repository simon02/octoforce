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

end
