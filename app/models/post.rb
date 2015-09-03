class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  belongs_to :next, class_name: "Post", foreign_key: "next_id"
  has_many :content_items, dependent: :nullify
  before_save :check_position

  def previous
    Post.where(next_id: self.id).first
  end

  def providers
    content_items.map(&:identity).delete_if &:nil?
  end

  def content_item_for_identity identity
    content_items.where(identity: identity).first
  end

  def text_for_identity identity
    content_item = content_items.where(identity: identity).first
    content_item ? content_item.text : ""
  end

  def text
    content_items.first.text
  end

  def has_media?
    !content_items.first.asset.nil?
  end

  def media_url options = {}
    options = :original if options.empty?
    content_items.first.asset.media.url options
  end

  private

  def check_position
    self.position = self.list.posts.count unless self.list.nil? || !self.position.nil?
  end

end
