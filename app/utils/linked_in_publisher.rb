class LinkedInPublisher

  def self.publish update, client
    params = { comment: update.text }
    if update.link
      params.merge content: {
        title: link.title,
        description: link.description,
        'submitted-­url': link.url,
        'submitted-image-url': link.image_url
      }
    end
    client.add_share params
  end

end
