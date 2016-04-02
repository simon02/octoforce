class QueueWorker
  include Sidekiq::Worker

  def perform list_id
    list = List.find_by id: list_id
    return if !list || list.timeslots.empty? || list.posts.empty?
    list.reschedule(2)
  end

end
