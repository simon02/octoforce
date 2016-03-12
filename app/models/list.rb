class List < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :timeslots, dependent: :nullify
  has_many :updates, dependent: :nullify
  after_initialize do |list|
    @generator = ColorGenerator.new saturation: 0.5, lightness: 0.5 unless @generator
    list.color ||= @generator.create_hex
  end

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

  def first_position
    first = posts.order(:position).first
    first ? first.position : 100
  end

  def last_position
    posts.sorted.last.position
  end

  def find_next_post
    posts.sorted.first
  end

  def reschedule weeks = 1
    updates.scheduled.each &:unschedule
    slots = timeslots.sort_by { |t| [t.day, t.offset] }
    now = Time.zone.now.to_date
    year = now.year
    week = now.cweek
    slots.each do |slot|
      time = slot.calculate_scheduling_time year, week
      # timeslots that are before now should be scheduled next week
      slot.schedule_next_update year, (time < now ? week + 1 : week)
    end
  end

  def number_of_unique_days
    return 0 if updates.count == 0
    return -1 if timeslots.count == 0
    ((posts.count * 7)/ timeslots.count).to_i
  end

  private

  def find_first_post
    updates = self.updates.scheduled.sort_by &:scheduled_at
    if updates.empty?
      self.next_post
    else
      updates.first.content_item.post
    end
  end

end
