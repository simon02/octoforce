# Schedule new updates for all users
class ScheduleNewUpdatesWorker
  include Sidekiq::Worker

  def perform user_id = nil
    if user_id
      schedule_for_user User.find(user_id)
    else
      User.all.map { |user| schedule_for_user user }
    end
  end

  def schedule_for_user user
    end_time = (Time.zone.now + 2.weeks)
    user.categories.each do |category|
      next if category.timeslots.empty? || category.posts.empty?
      start_time = category.updates.scheduled.empty? ?
        Time.zone.now :
        # add 1 so last update doesn't get scheduled again
        category.updates.scheduled.sorted.last.scheduled_at + 1
      category.schedule_between start_time, end_time
    end
  end

end
