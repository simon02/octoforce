module SchedulesHelper

  def day_options
    days = Date::DAYNAMES.each_with_index.map { |d,i| [d, i] }
    sunday = days.shift
    days << sunday
  end

  def category_options
    current_user.categories.map { |l| ["#{l.name} (#{l.posts.count})", l.id] }
  end

  def block_time block, format
    offset = block * minutes_per_block
    offset_to_time offset, format
  end

  def offset_to_time offset, format
    time = Time.zone.now.change({ hour: offset / 60, min: offset % 60 }) # offset is in minutes!
    time.strftime(format)
  end

  def minute_blocks_per_day
    24*60/minutes_per_block
  end

  # this will take a schedule and group the timeslots per day and then by timeblock (ie. per 30 minute interval)
  def convert_to_timeblocks schedule
    slots = schedule.timeslots.order(:offset).group_by(&:day)
    Hash[slots.map { |i,slots| [i, slots.group_by { |slot| slot.offset / minutes_per_block }]}]
  end

  def minutes_per_block
    120
  end

end
