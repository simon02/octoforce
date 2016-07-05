class SchedulingFacade
  attr_reader :user

  def self.reschedule_category category, weeks = 1
    category.updates.scheduled.sorted.reverse.each &:unschedule
    # sunday is 0, but we actually want those last, so we mess a little with the index here
    slots = category.timeslots
    now = Time.zone.now
    scheduling_times = calculate_scheduling_times_for_one_week slots, now
    weeks.times do |week_nr|
      scheduling_times.each do |h|
        schedule_post h[:timeslot], h[:time] + week_nr.weeks
      end
    end
  end

  def self.skip_update update
    identity = update.identity
    category = update.category
    post = update.post

    update.unschedule
    post.move_to_back identity
    reschedule_category category, 2
  end

  def self.schedule_new_updates category, end_time
    return if category.timeslots.empty? || category.posts.empty?
    start_time = category.updates.scheduled.empty? ?
      Time.zone.now :
      # add 1 so last update doesn't get scheduled again
      category.updates.scheduled.sorted.last.scheduled_at + 1

    scheduling_times = calculate_scheduling_times_for_one_week category.timeslots, start_time
    week_nr = 0
    loop do
      break if scheduling_times.empty? || (scheduling_times.first[:time] + week_nr.weeks) > end_time
      scheduling_times.each do |h|
        scheduling_time = h[:time] + week_nr.weeks
        next if scheduling_time < start_time || scheduling_time > end_time
        schedule_post h[:timeslot], scheduling_time
      end
      week_nr += 1
    end
  end

  # Time should be an UTC representation of the user time, not server time
  def self.schedule_post timeslot, time
    timeslot.identity_ids.each do |id|
      smp = timeslot.category.social_media_posts.sorted.identity(id).first
      next unless smp
      Update.create \
        user: timeslot.user,
        timeslot: timeslot,
        category: timeslot.category,
        post: smp.post,
        asset: smp.post.asset,
        link: smp.post.link,
        identity_id: id,
        text: smp.post.text,
        scheduled_at: time
      smp.move_to_back
    end
  end

  private

  def self.calculate_scheduling_times_for_one_week slots, from
    result = []
    slots.each do |slot|
      time = slot.calculate_scheduling_time_after from
      result << { timeslot: slot, time: time }
    end
    result.sort_by { |r| r[:time] }
  end

end
