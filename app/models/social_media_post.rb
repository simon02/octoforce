class SocialMediaPost < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :identity
  has_one :user, through: :post
  has_one :category, through: :post
  has_many :updates, through: :post
  scope :sorted, -> { order(position: :ASC) }
  scope :identity, -> (identity_id) { find_by identity_id: identity_id }

  def move_to_front
    self.update position: category.first_position - 1
  end

  def move_to_back
    self.update position: category.last_position + 1
  end

end
