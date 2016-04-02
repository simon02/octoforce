class QueueWorker
  include Sidekiq::Worker

  def perform list_id, start_time = nil, end_time = nil
    start_time = Time.at start_time if start_time.is_a? Integer
    end_time = Time.at end_time if end_time.is_a? Integer

    list = List.find_by id: list_id
    return if !list || list.timeslots.empty? || list.posts.empty?
    if start_time.nil? && end_time.nil?
      list.reschedule(2)
    elsif end_time.nil?
      list.schedule_between start_time, Time.now + 2.weeks
    else
      list.schedule_between start_time, end_time
    end
  end

end
