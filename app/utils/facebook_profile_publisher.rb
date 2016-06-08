class FacebookProfilePublisher < FacebookPublisher

  def self.publish update, client
    publish_to_facebook 'me', update, client
  end

end
