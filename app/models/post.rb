class Post < ActiveRecord::Base
  include Filterable
  serialize :providers, Array
  belongs_to :user, touch: true
  belongs_to :category, touch: true
  belongs_to :asset
  has_many :updates, dependent: :nullify
  has_one :link
  accepts_nested_attributes_for :link
  before_destroy :teardown, prepend: true
  before_save :check_position
  scope :sorted, -> { order(:position) }
  scope :category, -> (category_id) { where category_id: category_id.split(',') }
  scope :q, -> (query) { where('text LIKE ?', "%#{query}%")}
  scope :provider, -> (name) { where('providers LIKE ?', "%#{name}%")}

  def previous
    Post.where(next_id: self.id).first
  end

  def has_media?
    # !asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    # asset.media.url options
  end

  def schedule at, identity
    u = Update.new \
      text: text,
      asset: asset,
      scheduled_at: at,
      user: user,
      category: category,
      identity: identity
    if identity.provider.in? [Identity::FACEBOOK_PROFILE, Identity::FACEBOOK_PAGE, Identity::FACEBOOK_GROUP]
      u.link = link
    end
    updates << u
    move_to_back
    u
  end

  def move_to_front
    category.move_to_front self
  end

  def move_to_back
    category.move_to_back self
  end

  def potential_providers
    %w{twitter facebook}
  end

  private

  def check_position
    self.position = self.category.posts.count unless self.category.nil? || !self.position.nil?
  end

  def teardown
    self.updates.published(false).destroy_all
  end

end
