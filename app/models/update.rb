class Update < ActiveRecord::Base
  belongs_to :content_item
  belongs_to :user
  belongs_to :timeslot
  belongs_to :list

  def text
    content_item.text
  end

  def has_media?
    !content_item.asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    content_item.asset.media.url options
  end

end
