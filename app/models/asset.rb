class Asset < ActiveRecord::Base
  belongs_to :user
  has_many :posts
  has_many :updates, autosave: true
  has_attached_file :media, styles: { thumb: "200x200>" }
  validates_attachment :media, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { less_than: 2.megabytes }
end
