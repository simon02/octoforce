class Category < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :timeslots, dependent: :nullify
  has_many :updates, dependent: :nullify
  has_many :feeds, dependent: :destroy
  after_initialize do |category|
    @generator = ColorGenerator.new saturation: 0.5, lightness: 0.5 unless @generator
    category.color ||= @generator.create_hex
  end

  def move_to_front post
    post.update position: (self.first_position - 1)
    post.update category: self if post.category.nil?
  end

  def move_to_back post
    post.update position: (self.last_position + 1)
    post.update category: self if post.category.nil?
  end

  def first_position
    first = posts.sorted.first
    first ? first.position : 100
  end

  def last_position
    posts.empty? ? 100 : posts.sorted.last.position
  end

  def find_next_post
    posts.sorted.first
  end

  def sorted_posts
    # always first show scheduled posts, based on scheduling time (should match position)
    # NB: we don't want to show posts with multiple scheduled updates ahead of the pack (reason for the weird zero? construction)
    posts.sort_by { |post| [post.updates.scheduled.count.zero? ? 0 : -1, post.position] }
  end

  def reschedule weeks = 1
    updates.scheduled.sorted.reverse.each &:unschedule
    # sunday is 0, but we actually want those last, so we mess a little with the index here
    slots = timeslots.sort_by { |t| [(t.day - 1)%7, t.offset] }
    now = Time.zone.now
    year = now.year
    week = now.to_date.cweek
    backlog = []
    first = []
    last = []
    slots.each do |slot|
      scheduling_time = slot.calculate_scheduling_time year, week
      # timeslots that are before now should be scheduled next week
      if scheduling_time < now
        last << slot
      else
        first << slot
      end
    end
    weeks.times do |time|
      first.each do |slot|
        slot.schedule_next_update year, week
      end
      last.each do |slot|
        slot.schedule_next_update year, week + 1
      end
      week += 1
    end
  end

  def number_of_unique_days
    return 0 if updates.count == 0
    return -1 if timeslots.count == 0
    ((posts.count * 7)/ timeslots.count).to_i
  end

  def schedule_between start_time, end_time
    # break up into weeks - otherwise timeslot will only schedule one instance
    # can we alter this to use iteration over recursion?
    if end_time - start_time >= 7.days
      self.schedule_between start_time, start_time + 7.days - 1
      self.schedule_between start_time + 7.days, end_time
    else
      timeslots.each do |timeslot|
        scheduled_time = timeslot.calculate_scheduling_time_between start_time, end_time
        timeslot.updates << find_next_post.schedule(scheduled_time, timeslot.schedule.identity) unless scheduled_time.nil?
      end
    end
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
