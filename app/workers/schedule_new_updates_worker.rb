# Schedule new updates for all users
class ScheduleNewUpdatesWorker
  include Sidekiq::Worker

  def perform
    # List.each do |list|
    #   QueueWorker.perform_async list
    # end
  end

end
