class Timeslot < ActiveRecord::Base
  belongs_to :list
  belongs_to :schedule
  has_many :updates, dependent: :nullify
  validates_presence_of :day, :offset

  def schedule_next_update year, week
    post = list.find_next_post
    return unless post
    update = post.schedule calculate_scheduling_time(year, week)
    update.update timeslot: self, identity: schedule.identity
  end

  # calculate schedule time based on given week + own weekday and time
  def calculate_scheduling_time year, week
    date = Date.commercial(year, week, self.day == 0 ? 7 : self.day)
    datetime = date.to_time + self.offset * 60
    schedule.user.time_zone.local_to_utc(datetime)
  end

end
