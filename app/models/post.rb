class Post < ActiveRecord::Base
  include Filterable
  belongs_to :user, touch: true
  belongs_to :category, touch: true
  has_many :updates, dependent: :nullify
  has_many :social_media_posts, dependent: :destroy
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

  def move_to_front
    category.move_to_front self
  end

  def move_to_back
    category.move_to_back self
  end

  def link
    social_media_posts.map(&:link).first
  end

  def identity_ids
    social_media_posts.map(&:identity_id)
  end

  private

  def check_position
    self.position = self.category.posts.count unless self.category.nil? || !self.position.nil?
  end

  def teardown
    self.updates.published(false).destroy_all
  end

end
