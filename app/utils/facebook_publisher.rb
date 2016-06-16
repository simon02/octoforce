class FacebookPublisher

  def self.publish_to_facebook target, update, client
    if !update.link.nil?
      feed = 'feed'
      params = { message: update.text, link: update.link.url, caption: update.link.caption, description: update.link.description, name: update.link.title }
      if update.link.image_url || update.has_media?
        params[:picture] = update.link.image_url || update.media_url
      end
    elsif update.has_media?
      feed = 'photos'
      params = { caption: update.text, url: update.media_url }
    else
      feed = 'feed'
      params = { message: update.text }
    end
    client.put_connections target, feed, params
  end

end
