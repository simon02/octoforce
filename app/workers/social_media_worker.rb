class SocialMediaWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed
  sidekiq_options :retry => 3
  sidekiq_retry_in do |count|
    (retry_count ** 5) + 60 + (rand(30) * (retry_count + 1))
  end

  def perform update_id
    update = Update.find_by id: update_id
    SocialMediaPublisher.publish update
  end

end
