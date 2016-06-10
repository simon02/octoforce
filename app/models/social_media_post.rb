class SocialMediaPost < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :identity
  belongs_to :asset
  belongs_to :link
  has_one :user, through: :post
  has_many :updates, through: :post

end
