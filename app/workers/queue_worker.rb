class QueueWorker
  include Sidekiq::Worker

  def perform category_id
    category = Category.find_by id: category_id
    return if !category
    SchedulingFacade.reschedule_category category, 2
  end

end
