class SchedulesController < ApplicationController
  skip_before_filter :onboarding, only: :add_timeslot

  def index
    @schedules = current_user.schedules.includes(:timeslots)
    @identities = current_user.identities
    @new_timeslot = Timeslot.new
  end

  def add_timeslot
    schedule = Schedule.find timeslot_params[:schedule_id]
    # event tracking
    intercom_event 'created-timeslot', timeslots_in_schedule: schedule.timeslots.count, number_of_schedules: current_user.schedules.count

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
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :category_id)
  end

end
