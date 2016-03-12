class Asset < ActiveRecord::Base
  belongs_to :user
  has_many :posts
  has_many :updates
  has_attached_file :media, styles: { thumb: "200x200>" },
            :storage => :s3,
            :bucket  => ENV['S3_BUCKET_NAME']
  validates_attachment :media, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { less_than: 2.megabytes }
end
