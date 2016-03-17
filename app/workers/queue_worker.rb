class QueueWorker
  include Sidekiq::Worker

  # def perform schedule_id
  #   schedule = Schedule.find(schedule_id)
  #   schedule.reschedule(2) if schedule.outdated? && schedule.identity
  # end

  def perform list_id
    list = List.find_by id: list_id
    return if !list || list.timeslots.empty? || list.posts.empty?
    list.reschedule if list
  end

end
