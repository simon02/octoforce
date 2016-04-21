class TimeslotsController < ApplicationController

  def new
    @timeslot = Timeslot.build
  end

  def create
    schedule = Schedule.find timeslot_params[:schedule_id]
    # event tracking
    intercom_event 'created-timeslot', timeslots_in_schedule: schedule.timeslots.count, number_of_schedules: current_user.schedules.count, social_media: schedule.identity.provider

    @timeslot = Timeslot.create_with_timestamp timeslot_params

    QueueWorker.perform_async(@timeslot.category.id)

    respond_to do |format|
      format.html { redirect_to schedules_path(@slot.schedule) }
      format.js
    end
  end

  def edit
  end

  def destroy
    puts "THIS GETS CALLED!!!"
    @timeslot = Timeslot.find(params[:id]).destroy

    QueueWorker.perform_async(@timeslot.category.id)

    respond_to do |format|
      format.html { redirect_to schedules_path }
      format.js
    end
  rescue
    flash[:error] = "An error occured."
    redirect_to schedules_path
  end

  private

  def timeslot_params
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :category_id)
  end

end
