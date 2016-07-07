class SchedulesController < ApplicationController
  skip_before_filter :onboarding, only: :add_timeslot

  def index
    @timeslots = current_user.timeslots.filter(filtering_params)
    @identities = current_user.identities
    @new_timeslot = Timeslot.new
  end

  def add_timeslot
    offset = Time.zone.parse(timeslot_params[:offset].sub('.',':'))
    @timeslot = Timeslot.create timeslot_params.merge offset: (offset.hour * 60 + offset.min)

    QueueWorker.perform_async(@timeslot.category.id)

    respond_to do |format|
      format.html { redirect_to schedules_path }
      format.js
    end
  end

  def reschedule
    @schedule = Schedule.find params[:schedule_id]
    @schedule.reschedule
  end

  private

  def timeslot_params
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :category_id, identity_ids: [])
  end

  def filtering_params
    params.slice :identities
  end


end
