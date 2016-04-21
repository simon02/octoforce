class AnalyticsWorker
  include Sidekiq::Worker

  def perform user_id = nil
    if user_id.nil?
      User.all.each { |user| AnalyticsWorker.perform_async user.id }
    else
      perform_with_user user_id
    end
  end

  # only doing twitter right now
  # Future ref: move this to TwitterAnalyticsWorker
  def perform_with_user user_id
    user = User.find_by id: user_id
    # TK log this
    return if user.nil?
    user.identities.each do |identity|
      twitter_analytics identity if identity.provider == 'twitter'
    end
  end

  def twitter_analytics identity
    # TK split into chunks of 100 updates each
    updates = identity.updates.published.time_ago(:published_at, Time.zone.now - 1.month).limit(100)
    # response_ids that are nil, twitter won't return a result for
    tweets = identity.client.statuses updates.map(&:response_id), trim_user: true
    tweets.each do |tweet|
      parse_tweet tweet
    end
  # rescue Twitter::Error::Unauthorized
  #   # TK update status on update with a status code
  # rescue Twitter::Error::DuplicateStatus
  #   # TK update status on update with a status code
  # rescue Twitter::Error::Forbidden
  #   # TK update status on update with a status code
  # rescue
  #   # TK update status on update with a status code
  end

  # Looks for the update
  def parse_tweet tweet
    update = Update.find_by response_id: tweet.id.to_s
    if update
      update.likes = tweet.favorite_count
      update.shares = tweet.retweet_count
      update.save
    end
  end

end
