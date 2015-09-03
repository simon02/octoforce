module SchedulesHelper

  def day_options
    days = Date::DAYNAMES.each_with_index.map { |d,i| [d, i] }
    sunday = days.shift
    days << sunday
  end

  def list_options
    current_user.lists.map { |l| ["#{l.name} (#{l.posts.count})", l.id] }
  end

  def offset_to_time offset
    Time.new(0,1,1,offset / 60, offset % 60, 0, current_user.time_zone).strftime("%I:%M%p") # offset is in minutes!
  end

end
