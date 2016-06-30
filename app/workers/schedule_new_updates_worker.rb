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
      SchedulingFacade.schedule_new_updates category, end_time
    end
  end

end
