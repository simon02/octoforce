class List < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :timeslots, dependent: :nullify
  has_many :updates, dependent: :nullify

  def move_to_front post
    post.update position: (self.first_position - 1)
    if post.list_id
      self.posts(true)
    else
      self.posts << post
    end
  end

  def move_to_back post
    post.update position: (self.last_position + 1)
    self.posts << post unless post.list_id
    self.posts(true)
  end

  def scheduled_updates
    self.updates.where "scheduled_at > ?", Time.now
  end

  def sorted_posts
    # use true, because the changes in move_to_{front/back} are not registered in this model, we don't want to use the cached values
    self.posts.sort_by &:position
  end

  def first_position
    first = posts.order(:position).first
    first ? first.position : 100
  end

  def last_position
    sorted_posts.last.position
  end

  def find_next_post
    sorted_posts.first
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
