class TwitterPost < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :asset
  after_save :update_updates

  def has_media?
    !asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    asset.media.url options
  end

  def schedule at, identity, update = nil
    Update.new \
      text: text,
      asset: asset,
      scheduled_at: at,
      user: post.user,
      category: post.category,
      identity: identity
  end

  private

  def update_updates
  end

end
