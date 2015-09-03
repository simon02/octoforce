class HistoryController < ApplicationController

  def index
    @updates = current_user.updates.where(published: true).order "scheduled_at DESC"
  end

end
