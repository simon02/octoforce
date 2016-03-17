class Schedule < ActiveRecord::Base
  belongs_to :identity
  belongs_to :user
  after_create :setup
  has_many :timeslots, dependent: :destroy
  has_many :updates, through: :timeslots

  def timeslots_on day
    self.timeslots.where day: day
  end

  def remove_scheduled_updates
    updates.scheduled.order(scheduled_at: :desc).each { |u| u.unschedule }
  end

  def number_of_unique_days
    return -1 if timeslots.count == 0
    timeslots.map(&:list).map(&:number_of_unique_days).uniq.min
  end

  private

  def setup
    if user.schedules.count == 1
      lists = user.lists
      timeslots << Timeslot.create_with_timestamp(day: 1, offset: '7:04am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 1, offset: '11:41am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 1, offset: '3:00pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 2, offset: '7:32am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 2, offset: '1:02pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 2, offset: '4:55pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 3, offset: '8:01am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 3, offset: '1:22pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 3, offset: '3:50pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 4, offset: '7:43am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 4, offset: '12:14pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 4, offset: '4:20pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 5, offset: '8:23am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 5, offset: '11:58pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 5, offset: '2:41pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 6, offset: '7:32am', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 6, offset: '12:30pm', list: lists.sample)
      timeslots << Timeslot.create_with_timestamp(day: 6, offset: '4:00pm', list: lists.sample)
    end
  end

end
