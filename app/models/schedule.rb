class Schedule < ActiveRecord::Base
  belongs_to :identity
  belongs_to :user
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
    timeslots.map(&:category).map(&:number_of_unique_days).uniq.min
  rescue
    return -1
  end

end
