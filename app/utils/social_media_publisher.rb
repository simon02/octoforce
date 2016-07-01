class SocialMediaPublisher

  def self.publish update
    # we need an update, identity and client to proceed
    client = update.identity.client if update && update.identity
    return unless client

    case update.identity.provider
    when Identity::FACEBOOK_PROFILE
      fb = FacebookProfilePublisher.publish update, client
      published_update update, fb['id'] if fb['id']
    when Identity::FACEBOOK_PAGE
      fb = FacebookPagePublisher.publish update, client
      published_update update, fb['id'] if fb['id']
    when Identity::FACEBOOK_GROUP
      fb = FacebookGroupPublisher.publish update, client
      published_update update, fb['id'] if fb['id']
    when Identity::GITHUB
    when Identity::INSTAGRAM
    when Identity::LINKEDIN
    when Identity::TWITTER
      tweet = TwitterPublisher.publish update, client
      published_update update, tweet.id.to_s if tweet
    end
  end

  def self.published_update update, response
    update.published = true
    update.published_at = Time.zone.now
    update.response_id = response
    update.save
  end

  def self.generate_short_links text, owner = nil
    text = text.clone
    urls = Twitter::Extractor.extract_urls text
    mapping = urls.map do |url|
      short_url = "#{ENV['SHORTEN_HOSTNAME']}/" + Shortener::ShortenedUrl.generate(url, owner: owner).unique_key
      short_url = "#{ENV['SHORTEN_SUBDOMAIN']}.#{short_url}" if ENV['SHORTEN_SUBDOMAIN']
      [url, short_url]
    end
    mapping.each { |l| text.sub!(l[0], l[1])}
    text
  end

end
