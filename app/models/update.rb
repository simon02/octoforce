class Update < ActiveRecord::Base
  include Filterable
  has_shortened_urls
  belongs_to :user
  belongs_to :timeslot
  belongs_to :category, touch: true
  belongs_to :asset
  belongs_to :post, touch: true
  belongs_to :identity, touch: true
  scope :scheduled, -> { where("scheduled_at > ?", Time.zone.now) }
  scope :published, -> pub = true { where("published = ?", pub) }
  scope :sorted, -> { order("scheduled_at ASC") }
  scope :time_ago, -> (field, time) { where("? >= ?", field.to_s, time)}
  scope :category, -> (category_ids) { where category_id: category_ids.split(',').flatten }
  scope :identity, -> (identity_ids) { where identity_id: identity_ids.split(',').flatten }

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

  def category_color
    category ? category.color : '757575'
  end

  def social_media_url
    return nil if !published || identity.provider != 'twitter'
    "https://twitter.com/octoforce/status/#{response_id}"
  end

end
