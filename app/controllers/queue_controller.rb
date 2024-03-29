class QueueController < ApplicationController

  def index
    @filtering_params = filtering_params
    @updates = current_user.updates.published(false)
      .includes(:identity, :category)
      .filter(@filtering_params).sorted
      # .group_by { |u| u.scheduled_at.to_date }
    @identities = current_user.identities.includes(:updates)
    @categories = current_user.categories.includes(:updates)
  end

  def reschedule
    intercom_event 'rescheduled-queue-manually'

    current_user.categories.each do |category|
      QueueWorker.perform_async category.id
      # category.reschedule
    end
    redirect_to queue_url
  end

  def skip
    update = Update.find_by id: params["update_id"]
    authorize! :skip, update
    SchedulingFacade.skip_update update
    redirect_to queue_path(filtering_params)
  end

  private

  def filtering_params
    params.slice(:category, :identity)
  end

end
