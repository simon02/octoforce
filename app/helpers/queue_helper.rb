module QueueHelper

  def split_updates_in_days
    @updates.group_by { |u| u.scheduled_at.to_date }
  end

end
