class TwitterWorker
  include Sidekiq::Worker

  def perform tweet_id
    tweet = Update.find(tweet_id)
    if tweet.image.exists?
      tweet.identity.client.update_with_media(tweet.text, open(tweet.image.url))
    else
      tweet.identity.client.update(tweet.text)
    end
    tweet.published = true
    tweet.save
  end

end
