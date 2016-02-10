module QueueHelper

  def calculate_local_time update
    tz = current_user.time_zone
    tz.utc_to_local update.scheduled_at
  end

end
