class UpdateSchedulerWorker
  include Sidekiq::Worker

  def perform
    time = Time.now + 1.hour
    Update.where("published = false AND scheduled_at < '#{time}'").each do |update|
      update.jid = TwitterWorker.perform_at(update.scheduled_at, update.id)
      update.save
    end
  end

end
