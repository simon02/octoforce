class SchedulingFacade

  def reschedule_category category, weeks = 1
    category.updates.scheduled.sorted.reverse.each &:unschedule
    # sunday is 0, but we actually want those last, so we mess a little with the index here
    slots = category.timeslots
    now = Time.zone.now
    scheduling_times = calculate_scheduling_times slots, now, now + (weeks).weeks
    scheduling_times.each do |hash|
      schedule_post category, identity, time
    end
  end

  def schedule_post social_media_post, timeslot, at
    Update.new \
      user: timeslot.user,
      timeslot: timeslot,
      category: timeslot.category,
      asset: social_media_post.asset,
      post: social_media_post.post,
      link: social_media_post.link,
      identity: social_media_post.identity,
      text: social_media_post.text,
      scheduled_at: at
  end

  private

  def calculate_scheduling_times slots, from, to
    result = []
    slots.each do |slot|
      time = calculate_scheduling_time slot, from
      result << { timeslot: slot, time: time } if time < to
    end
    result.sort_by { |r| r[:time] }
  end

end
