class Schedule < ActiveRecord::Base
  belongs_to :identity
  belongs_to :user
  has_many :timeslots, dependent: :destroy
  has_many :updates, through: :timeslots

  def timeslots_on day
    self.timeslots.where day: day
  end

  def outdated?
    true
  end

  def reschedule weeks
    puts "Lets get our reschedule ON"
    remove_scheduled_updates
    today = Date.today
    schedule Time.zone.now, 7 * weeks
  end

  def schedule starting_time, days
    starting_date = starting_time.to_date
    days.times do |day|
      timeslots_on(starting_date.wday).each do |timeslot|
        if timeslot.calculate_scheduling_time(starting_date.year, starting_date.cweek) < starting_time
          next
          puts "Skipping timeslot!"
        end
        timeslot.schedule_next_update starting_date.year, starting_date.cweek
      end
      starting_date += 1.day
    end
  end

  def remove_scheduled_updates
    updates.scheduled.order(scheduled_at: :desc).each { |u| u.unschedule }
  end

  def number_of_unique_days
    return -1 if timeslots.count == 0
    timeslots.map(&:list).map(&:number_of_unique_days).uniq.min
  end

end
