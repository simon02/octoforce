class SocialMediaWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform update_id
    update = Update.find_by id: update_id
    client = update.identity.client if update && update.identity
    # updates can be destroyed between scheduling and execution
    return unless client

    case update.identity.provider
    when 'facebook'
      perform_facebook update, client
      break
    when 'facebook_page'
      perform_facebook_page update, client
      break
    when 'facebook_group'
      perform_facebook_group update, client
      break
    when 'github'
    when 'google'
    when 'instagram'
    when 'twitter'
      perform_twitter update, client
    end
  end

  def perform_twitter update, client
    shorten_links = update.user.shorten_links
    if update.has_media?
      tweet = client.update_with_media(shorten_links ? SocialMediaWorker.generate_short_links(update.text, update) : update.text, open(update.media_url))
    else
      tweet = client.update(shorten_links ? SocialMediaWorker.generate_short_links(update.text, update) : update.text)
    end
    update.published = true
    update.published_at = Time.zone.now
    update.response_id = tweet.id.to_s
    update.save
  end

  def perform_facebook update, client
    if update.has_media?
      client.put_connections("me", "photos", caption: update.text, url: update.media_url)
    # elsif update.contains_link?
    #   params = { message: update.text, link: update.link.url, caption: update.link.caption, description: update.link.description, name: update.link.title }
    #   if update.link.custom_image?
    #     response = client.put_connections("me", "photos", caption: update.text, url: update.media_url, no_story: true)
    #     fbid = response["id"]
    #     params[:object_attachment] = fbid
    #   end
    #   client.put_connections("me", "feed", params)
    else
      client.put_connections("me", "feed", message: update.text)
    end
  end

  def perform_facebook_page update, client
    # if update.has_media?
      # client.put_connections("me", "photos")
    # else
      client.put_connections(update.identity.uid, "feed", message: update.text)
    # end
  end

  def perform_facebook_group update, client
    # if update.has_media?
      # client.put_connections("me", "photos")
    # else
      client.put_connections("me", "feed", message: update.text)
    # end
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
