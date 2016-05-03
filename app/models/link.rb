class Link < ActiveRecord::Base
  belongs_to :post, touch: true
  has_many :updates
end
