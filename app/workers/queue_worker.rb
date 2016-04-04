class QueueWorker
  include Sidekiq::Worker

  def perform category_id
    category = Category.find_by id: category_id
    return if !category
    category.reschedule(2)
  end

end
