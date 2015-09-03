class SchedulesController < ApplicationController

  def index
    @schedules = current_user.schedules
    @timeslot = Timeslot.new
  end

  def add_timeslot
    Timeslot.create timeslot_params
    redirect_to schedules_path
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
