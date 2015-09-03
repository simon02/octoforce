class Schedule < ActiveRecord::Base
  belongs_to :identity
  belongs_to :user
  has_many :timeslots, dependent: :destroy

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
    schedule Date.today, 14
  end

  def schedule starting_time, days
    starting_date = starting_time.to_date
    days.times do |day|
      puts starting_date.wday
      timeslots_on(starting_date.wday).each do |timeslot|
        if timeslot.calculate_scheduling_time(starting_date.year, starting_date.cweek) < starting_time
          next
          puts "Skipping timeslot!"
        end
        puts "#{timeslot.inspect}"
        timeslot.schedule_next_update starting_date.year, starting_date.cweek
      end
      starting_date += 1.day
    end
  end

  def remove_scheduled_updates
    timeslots.each do |timeslot|
      timeslot.remove_scheduled_updates
    end
  end

end
