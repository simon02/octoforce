class QueueWorker
  include Sidekiq::Worker

  def perform schedule_id
    schedule = Schedule.find(schedule_id)
    schedule.reschedule(2) if schedule.outdated?
  end

end
