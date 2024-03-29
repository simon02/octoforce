class TimeslotsController < ApplicationController

  def new
    @timeslot = Timeslot.new timeslot_params
  end

  def create
    offset = Time.zone.parse(timeslot_params[:offset].sub('.',':'))
    @timeslot = Timeslot.create timeslot_params.merge offset: (offset.hour * 60 + offset.min), user: current_user

    QueueWorker.perform_async(@timeslot.category.id)

    respond_to do |format|
      format.html { redirect_with_param schedules_path, notice: 'A timeslot has been added to your schedule.' }
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
      format.html { redirect_with_param schedules_path }
      format.js
    end
  rescue
    flash[:error] = "An error occured."
    redirect_to schedules_path
  end

  private

  def timeslot_params
    params.require(:timeslot).permit(:day, :offset, :category_id, identity_ids: [])
  end

end
