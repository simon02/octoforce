class TwitterPublisher

  def self.publish update, client
    shorten_links = update.user.shorten_links
    if update.has_media?
      tweet = client.update_with_media(update.text, open(update.media_url))
    else
      tweet = client.update(update.text)
    end
  end

end
