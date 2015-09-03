class Timeslot < ActiveRecord::Base
  belongs_to :list
  belongs_to :schedule
  has_many :updates, dependent: :nullify
  validates_presence_of :day, :offset
  after_create :trigger_create

  def schedule_next_update year, week
    post = list.next_post
    return unless post
    updates.create content_item: post.content_item_for_identity(schedule.identity), user: schedule.user, list: list, scheduled_at: calculate_scheduling_time(year, week)
    list.next_post = post.next
    list.save
  end

  # calculate schedule time based on given week + own weekday and time
  def calculate_scheduling_time year, week
    date = Date.commercial(year, week, self.day)
    Time.zone = self.schedule.user.time_zone
    Time.zone.local(date.year, date.month, date.day) + self.offset
  end

  def remove_scheduled_updates
    updates = self.updates.where("scheduled_at > ?", Time.now)
    return if updates.empty?
    post = updates.sort_by(&:scheduled_at).first.content_item.post
    self.list.next_post = post
    self.list.save
    updates.each &:destroy
  end

  private

  def trigger_create
    QueueWorker.perform_async(self.schedule.id) if self.schedule
  end

end
