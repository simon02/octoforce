class TimeslotsController < ApplicationController

  def new
    @timeslot = Timeslot.build
  end

  def create
    schedule = Schedule.find timeslot_params[:schedule_id]
    # event tracking
    intercom_event 'created-timeslot', timeslots_in_schedule: schedule.timeslots.count, number_of_schedules: current_user.schedules.count, social_media: schedule.identity.provider

    offset = Time.parse(timeslot_params[:offset])
    @slot = Timeslot.create(timeslot_params.merge offset: (offset.hour * 60 + offset.min))

    QueueWorker.perform_async(@slot.list.id)

    respond_to do |format|
        format.html { redirect_to schedules_path(@slot.schedule) }
        format.js
    end
  end

  def edit
  end

  def destroy
  end

  private

  def timeslot_params
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :list_id)
  end

end
