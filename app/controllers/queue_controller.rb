class QueueController < ApplicationController

  def index
    @updates = current_user.updates.scheduled.order :scheduled_at
    @identities = current_user.identities
    @lists = current_user.lists
    @new_list = List.new
  end

  def reschedule
    intercom_event 'rescheduled-queue-manually'

    current_user.lists.each do |list|
      QueueWorker.perform_async list.id
      # list.reschedule
    end
    redirect_to queue_url
  end

end
