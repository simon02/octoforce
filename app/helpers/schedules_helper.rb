module SchedulesHelper

  def day_options
    days = Date::DAYNAMES.each_with_index.map { |d,i| [d, i] }
    sunday = days.shift
    days << sunday
  end

  def list_options
    current_user.lists.map { |l| ["#{l.name} (#{l.posts.count})", l.id] }
  end

  def offset_to_time offset, format
    Time.new(0,1,1,offset / 60, offset % 60, 0, "+02:00").strftime(format) # offset is in minutes!
  end

  def minute_blocks_per_day minutes
    24*60/minutes
  end

  # this will take a schedule and group the timeslots per day and then by timeblock (ie. per 30 minute interval)
  def convert_to_timeblocks schedule, minutes
    slots = schedule.timeslots.group_by(&:day)
    Hash[slots.map { |i,slots| [i, slots.group_by { |slot| slot.offset / minutes }]}]
  end

end
