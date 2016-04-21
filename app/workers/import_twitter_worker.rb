class ImportTwitterWorker
  include Sidekiq::Worker

  def perform identity_id, count: 200, min_favorites: 1, min_retweets: 1, single_condition: true, skip_octoforce: true
    identity = Identity.find_by id: identity_id
    return if identity.nil?
  end

  def ss
    tweets = identity.client.user_timeline count: 200, trim_user: true, exclude_replies: true, include_rts: false
    tweets.each do |tweet|
      next if skip_octoforce && tweet.source.match(/octoforce/i)
      if single_condition
        next if tweet.favorite_count < min_favorites && tweet.retweet_count < min_retweets
      else
        next if tweet.favorite_count < min_favorites || tweet.retweet_count < min_retweets
      end
      save_tweet tweet, identity
    end
  end

  def save_tweet tweet, identity
    text = tweet.text.dup
    tweet.urls.each do |url|
      # TK error handling?
      text[url.indices[0]..url.indices[1]] = url.expanded_url.to_s
    end
    category = Category.find_or_create_by user: identity.user, name: 'twitter_import'
    update = category.updates.create text: text, likes: tweet.favorite_count, shares: tweet.retweet_count, response_id: tweet.id.to_s, published: true, published_at: tweet.created_at, user: identity.user, identity: identity
    # TK save the media
  end

end
