class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeslot
  belongs_to :list
  belongs_to :asset
  belongs_to :post
  belongs_to :identity

  def has_media?
    !asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    asset.media.url options
  end

  def unschedule
    post.unschedule
    self.destroy
  end

end
