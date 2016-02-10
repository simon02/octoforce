class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform tweet_id
    tweet = Update.find(tweet_id)
    # updates can be destroyed between scheduling and execution
    return unless tweet
    if tweet.has_media?
      tweet.identity.client.update_with_media(tweet.text, open(tweet.media_url))
    else
      tweet.identity.client.update(tweet.text)
    end
    tweet.published = true
    tweet.save
  end

end
