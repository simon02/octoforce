class Category < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :social_media_posts, through: :posts
  has_many :timeslots, dependent: :nullify
  has_many :updates, dependent: :nullify
  has_many :feeds, dependent: :destroy
  has_many :imported_updates, dependent: :destroy

  default_scope { order(name: :ASC) }

  after_initialize do |category|
    @generator = ColorGenerator.new saturation: 0.5, lightness: 0.5 unless @generator
    category.color ||= @generator.create_hex
  end

  def first_position
    first = social_media_posts.sorted.first
    first ? first.position || 100 : 100
  end

  def last_position
    social_media_posts.empty? ?
      100 :
      social_media_posts.sorted.last.position || 100
  end

  def find_next_post identity
    return nil unless identity
    social_media_posts.where('identity_id = ?', identity.id).sorted.first
  end

  def sorted_posts
    # always first show scheduled posts, based on scheduling time (should match position)
    # NB: we don't want to show posts with multiple scheduled updates ahead of the pack (reason for the weird zero? construction)
    posts.sort_by { |post| [post.updates.scheduled.count.zero? ? 0 : -1, post.position] }
  end

  def number_of_unique_days
    return 0 if updates.count == 0
    return -1 if timeslots.count == 0
    ((posts.count * 7)/ timeslots.count).to_i
  end

  def name_with_number
    "#{name} (#{posts.count})"
  end

end
