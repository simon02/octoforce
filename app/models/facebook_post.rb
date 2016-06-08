class FacebookPost < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :asset

  def schedule at, identity
    update = Update.new \
      text: text,
      asset: asset,
      scheduled_at: at,
      user: post.user,
      category: post.category,
      identity: identity
    if url
      update.create_link \
        url: url,
        description: description,
        caption: caption,
        title: title
    end
    return update
  end
end
