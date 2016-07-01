class FacebookPagePublisher < FacebookPublisher

  def self.publish update, client
    publish_to_facebook update.identity.uid, update, client
  end

end
