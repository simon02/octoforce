class UpdateSchedulerWorker
  include Sidekiq::Worker

  def perform
    time = Time.zone.now + 1.hour
    Update.where("published = false AND scheduled_at < '#{time}' AND jid IS NULL").each do |update|
      update.jid = SocialMediaWorker.perform_at(update.scheduled_at, update.id)
      update.save
    end
  end

end
