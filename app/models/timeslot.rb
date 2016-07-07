class Timeslot < ActiveRecord::Base
  include Filterable
  belongs_to :category
  belongs_to :user
  has_and_belongs_to_many :identities
  has_many :updates, dependent: :nullify
  validates_presence_of :day, :offset
  scope :identities, -> (identity_ids) { joins(:identities).where("identities.id IN (?)", identity_ids) }

  def self.create_with_timestamp params
    if params.key? :offset
      offset = Time.zone.parse(params[:offset].sub('.',':'))
      params[:offset] = offset.hour * 60 + offset.min
    end
    create params
  end

  # calculate schedule time based on given week + own weekday and time
  #
  # Result is a timestamp in UTC time based on user timezone!
  def calculate_scheduling_time year, week
    hours = offset / 60
    minutes = offset % 60
    datetime = calculate_date_commercial(year, week, self.day).to_datetime + hours.hours + minutes.minutes
    user.tzinfo.local_to_utc(datetime)
  end

  def calculate_scheduling_time_after time
    time = user.tzinfo.utc_to_local time
    date = calculate_scheduling_time time.year, calculate_week_number(time)
    return (date < time) ? date + 1.week : date
  end

  protected

  def calculate_week_number date
    date.to_date.cweek
  end

  def calculate_day_number date
    # sunday should be the 7th day!
    (date.wday - 1) % 7
  end

  def calculate_date_commercial year, week, day
    begin
      Date.commercial(year, week, day == 0 ? 7 : day)
    rescue ArgumentError
      Date.commercial(year + 1, 0, day == 0 ? 7 : day)
    end
  end

end
