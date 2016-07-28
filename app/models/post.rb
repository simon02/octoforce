class Post < ActiveRecord::Base
  include Filterable
  include TwitterValidator
  belongs_to :user, touch: true
  belongs_to :category, touch: true
  belongs_to :asset
  belongs_to :link
  accepts_nested_attributes_for :link, allow_destroy: true, update_only: true
  has_many :social_media_posts, dependent: :destroy
  accepts_nested_attributes_for :social_media_posts, allow_destroy: true
  has_many :updates, dependent: :nullify
  before_destroy :teardown, prepend: true
  scope :category, -> (category_id) { where category_id: category_id.split(',') }

  def previous
    Post.where(next_id: self.id).first
  end

  def has_media?
    !asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    asset.media.url options
  end

  def move_to_front identity = nil
    if identity
      smp = social_media_posts.identity(identity.id).first
      smp.move_to_front if smp
    else
      social_media_posts.update_all position: (category.first_position - 1)
    end
  end

  def move_to_back identity
    smp = social_media_posts.identity(identity.id).first
    smp.move_to_back if smp
  end

  def contains_provider? provider
    social_media_posts.map(&:identity).map(&:provider).include? provider.to_s
  end

  private

  def teardown
    self.updates.published(false).destroy_all
  end

end
