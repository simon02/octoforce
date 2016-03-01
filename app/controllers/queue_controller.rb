class QueueController < ApplicationController

  def index
    @updates = current_user.updates.where(published: false).order "scheduled_at"
    @identities = current_user.identities
    @lists = current_user.lists
  end

  def reschedule
    current_user.lists.each do |list|
      QueueWorker.perform_async list.id
    end
    redirect_to queue_url
  end

end
