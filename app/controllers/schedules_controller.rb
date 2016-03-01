class SchedulesController < ApplicationController

  def index
    @schedules = current_user.schedules
    @timeslot = Timeslot.new
  end

  def add_timeslot
    offset = Time.parse(timeslot_params[:offset])
    @timeslot = Timeslot.create timeslot_params.merge offset: (offset.hour * 60 + offset.min)
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
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :list_id)
  end

end
