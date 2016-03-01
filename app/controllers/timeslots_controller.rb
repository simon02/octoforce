class TimeslotsController < ApplicationController

  def new
    @timeslot = Timeslot.build
  end

  def create
    offset = Time.parse(timeslot_params[:offset])
    @slot = Timeslot.create(timeslot_params.merge offset: (offset.hour * 60 + offset.min))
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
