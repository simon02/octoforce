class QueueController < ApplicationController

  def index
    @updates = current_user.updates.where(published: false).order "scheduled_at"
  end

  def reschedule
    current_user.schedules.each do |schedule|
      QueueWorker.perform_async schedule.id
    end
    redirect_to queue_url
  end

end
