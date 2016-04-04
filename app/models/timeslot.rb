class Timeslot < ActiveRecord::Base
  belongs_to :category
  belongs_to :schedule
  has_many :updates, dependent: :nullify
  validates_presence_of :day, :offset

  def self.create_with_timestamp params
    if params.key? :offset
      offset = Time.parse(params[:offset])
      params[:offset] = offset.hour * 60 + offset.min
    end
    create params
  end

  def schedule_next_update year, week
    post = category.find_next_post
    unless post
      return
    else
      puts "Could not find the post :o"
    end
    update = post.schedule calculate_scheduling_time(year, week)
    update.update timeslot: self, identity: schedule.identity
  end

  # calculate schedule time based on given week + own weekday and time
  #
  # Result is a timestamp in UTC time based on user timezone!
  def calculate_scheduling_time year, week
    begin
      date = Date.commercial(year, week, day == 0 ? 7 : day)
    rescue ArgumentError
      date = Date.commercial(year + 1, 0, day == 0 ? 7 : day)
    end
    hours = offset / 60
    minutes = offset % 60
    datetime = date.to_datetime + hours.hours + minutes.minutes
    schedule.user.tzinfo.local_to_utc(datetime)
  end

  # Warning: make sure the times given are in UTC
  #
  # The returned timestamp is also in UTC
  def calculate_scheduling_time_between start_time, end_time
    week_nr = calculate_week_number start_time
    scheduled_time = calculate_scheduling_time(start_time.year, week_nr)
    if scheduled_time < start_time
      scheduled_time = calculate_scheduling_time(start_time.year, week_nr + 1)
    end
    return (scheduled_time <= end_time) ? scheduled_time : nil
  end

  protected

  def calculate_week_number date
    date.to_date.cweek
  end

  def calculate_day_number date
    # sunday should be the 7th day!
    (date.wday - 1) % 7
  end

end
