class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeslot
  belongs_to :list
  belongs_to :asset
  belongs_to :post
  belongs_to :identity
  scope :scheduled, -> { where("scheduled_at > ?", Time.zone.now) }
  scope :published, -> { where("published = true") }
  scope :sorted, -> { order("scheduled_at ASC") }
  scope :time_ago, -> (field, time) { where("? >= ?", field.to_s, time)}

  def has_media?
    !asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    asset.media.url options
  end

  def unschedule
    post.move_to_front
    self.destroy
  end

end
