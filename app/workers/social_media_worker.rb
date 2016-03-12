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
    when 'github'
    when 'google'
    when 'instagram'
    when 'twitter'
      perform_twitter update, client
    end
  end

  def perform_twitter update, client
    if update.has_media?
      client.update_with_media(update.text, open(update.media_url))
    else
      client.update(update.text)
    end
    update.published = true
    update.save
  end

  def perform_facebook update, client
    # if update.has_media?
      # client.put_connections("me", "photos")
    # else
      client.put_connections("me", "feed", message: update.text)
    # end
  end

end
