class Post < ActiveRecord::Base
  include Filterable
  belongs_to :user
  belongs_to :category
  belongs_to :asset
  has_many :updates, dependent: :nullify
  before_destroy :teardown, prepend: true
  before_save :check_position
  after_save :update_updates
  scope :sorted, -> { order(:position) }
  scope :category, -> (category_id) { where category_id: category_id.split(',') }
  scope :q, -> (query) { where('text LIKE ?', "%#{query}%")}

  def previous
    Post.where(next_id: self.id).first
  end

  def providers
    []
  end

  def text_for_identity identity
    text
  end

  def has_media?
    !asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    asset.media.url options
  end

  def schedule at
    u = updates.create scheduled_at: at, text: text, user: user, category: category, asset: asset
    move_to_back
    u
  end

  def move_to_front
    category.move_to_front self
  end

  def move_to_back
    category.move_to_back self
  end

  private

  def check_position
    self.position = self.category.posts.count unless self.category.nil? || !self.position.nil?
  end

  def update_updates
    self.updates.where(published: false).each do |update|
      update.text = self.text
      if self.has_media?
        update.asset = self.asset
      end
      update.save
    end
  end

  def teardown
    self.updates.scheduled.destroy_all
  end

end
