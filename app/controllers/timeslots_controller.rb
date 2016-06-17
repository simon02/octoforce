class TimeslotsController < ApplicationController

  def new
    @timeslot = Timeslot.new timeslot_params
  end

  def create
    puts timeslot_params
    @timeslot = Timeslot.create_with_timestamp timeslot_params

    QueueWorker.perform_async(@timeslot.category.id)

    respond_to do |format|
      format.html { redirect_to schedules_path(@timeslot.schedule) }
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
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :category_id, identity_ids: [])
  end

end
