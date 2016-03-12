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
    date = Date.commercial(year, week, day == 0 ? 7 : day)
    hours = offset / 60
    minutes = offset % 60
    datetime = date.to_datetime + hours.hours + minutes.minutes
    schedule.user.tzinfo.local_to_utc(datetime)
  end

end
