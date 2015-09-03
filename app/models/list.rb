class List < ActiveRecord::Base
  belongs_to :user
  belongs_to :next_post, class_name: "Post", foreign_key: "next_post_id"
  has_many :posts, dependent: :destroy
  has_many :timeslots, dependent: :nullify
  has_many :updates, dependent: :nullify

  def add_to_front post
    first_post = find_first_post || post
    last_post = first_post.previous || post
    self.next_post = post
    post.next = first_post
    last_post.next = post

    post.list = self

    self.save
    post.save
    first_post.save
    last_post.save

    # then we also need to update all scheduled updates
    unless updates.empty?
      content_item = post.content_item_for_identity updates.first.content_item.identity
    end
    self.scheduled_updates.sort_by(&:scheduled_at).each do |update|
      temp = update.content_item
      update.content_item = content_item
      update.save
      content_item = temp
    end
  end

  def add_to_back post
    if self.next_post.nil?
      self.next_post = post
      post.next = post
    else
      last_post = Post.where(next: self.next_post).first
      last_post.next = post
      last_post.save
      post.next = self.next_post
      self.next_post.next = post if self.next_post.next == self.next_post
    end
    post.list = self
    self.save
    post.save
  end

  def scheduled_updates
    self.updates.where "scheduled_at > ?", Time.now
  end

  def sorted_posts
    # puts list.posts
    sorted_posts = []
    current = self.next_post
    while current != sorted_posts.first do
      sorted_posts << current
      current = current.next
    end
    sorted_posts
  end

  private

  def find_first_post
    updates = self.scheduled_updates.sort_by &:scheduled_at
    if updates.empty?
      self.next_post
    else
      updates.first.content_item.post
    end
  end

end
