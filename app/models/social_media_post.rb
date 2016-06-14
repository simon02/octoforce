class SocialMediaPost < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :identity
  has_one :user, through: :post
  has_many :updates, through: :post
  scope :sorted, -> { order(position: :ASC) }

end
