class SocialMediaWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform update_id
    update = Update.find(update_id)
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
    if update.has_media?
      client.update_with_media(update.text[0..115], open(update.media_url))
    else
      client.update(update.text[0..139])
    end
    update.published = true
    update.save
  end

  def perform_facebook update, client
    if update.has_media?
      client.put_connections("me", "photos", caption: update.text, url: update.media_url)
    # elsif update.contains_link?
    #   params = { message: update.text, link: update.link.url, caption: update.link.caption, description: update.link.description }
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

end
