class QueueController < ApplicationController

  def index
    @updates = current_user.updates.scheduled.filter(filtering_params).sorted.group_by { |u| u.scheduled_at.to_date }
    @identities = current_user.identities
    @categories = current_user.categories
    @new_category = Category.new
  end

  def reschedule
    intercom_event 'rescheduled-queue-manually'

    current_user.categories.each do |category|
      QueueWorker.perform_async category.id
      # category.reschedule
    end
    redirect_to queue_url
  end

  private

  def filtering_params
    params.slice(:category, :identity)
  end

end
