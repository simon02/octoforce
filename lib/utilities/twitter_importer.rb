class TwitterImporter
  attr_reader :identity, :category, :max_id, :min_favorites, :min_retweets, :single_condition, :skip_octoforce

  def import identity, category, options = {}
    return if !identity || !category || !identity.user_id ||  identity.provider != 'twitter'

    @identity = identity
    @category = category
    @max_id = nil
    @min_favorites = (options[:min_favorites] || 1).to_i
    @min_retweets = (options[:min_retweets] || 1).to_i
    @single_condition = (options[:single_condition] || true).to_s.match(/(true|1|yes|t)/i)
    @skip_octoforce = (options[:skip_octoforce] || true).to_s.match(/(true|1|yes|t)/i)
    count = (options[:count] || 200).to_i

    (1 + count / 200).times do |c|
      params = {count: [count - c * 200, 200].min , trim_user: true, exclude_replies: true, include_rts: false}
      params[:max_id] = max_id - 1 if max_id
      import_twitter params
    end
  end

  private

  def import_twitter options = {}
    tweets = identity.client.user_timeline options
    tweets.each do |tweet|
      max_id = tweet.id
      next if skip_octoforce && tweet.source.match(/octoforce/i)
      if single_condition
        next if tweet.favorite_count < min_favorites && tweet.retweet_count < min_retweets
      else
        next if tweet.favorite_count < min_favorites || tweet.retweet_count < min_retweets
      end
      save_tweet tweet
    end
  end

  def save_tweet tweet
    text = tweet.text.dup
    replacement = tweet.urls.map { |u| [u.indices, u.expanded_url.to_s] }
    replacement << [tweet.media[0].indices, ''] if tweet.media?
    # order them based on position in the text, descending
    replacement.sort! { |a,b| b[0][0] <=> a[0][0] }
    replacement.each do |indices, url|
      text[indices[0]..indices[1] - 1] = url
    end
    text.strip!
    update = ImportedUpdate.create identity: identity, category: category, user_id: identity.user_id, text: text, likes: tweet.favorite_count, shares: tweet.retweet_count, original: "https://twitter.com/octoforce/status/#{tweet.id.to_s}", published_at: tweet.created_at
    if tweet.media?
      update.update media_url: tweet.media[0].media_url.to_s
    end
  end
end
