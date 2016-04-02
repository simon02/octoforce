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
    p user
    end_time = (Time.now + 2.weeks).to_i
    user.lists.each do |list|
      p list
      start_time = list.updates.scheduled.empty? ? Time.now.to_i : list.updates.scheduled.sorted.last.scheduled_at.to_i + 1
      list.schedule_between start_time, end_time
    end
  end

end
