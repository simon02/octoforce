class AnalyticsController < ApplicationController

  DEFAULT_RESULTS_PER_PAGE = 25

  def index
    @identities = current_user.identities.includes(:updates)
    @categories = current_user.categories.includes(:updates)
    @updates = current_user.updates.includes(:category).includes(:identity).published
      .order("published_at DESC")
      .filter(filtering_params)
    @filters = filtering_params
    if params[:count] && params[:offset]
      @count = params[:count].to_i
      @offset = params[:offset].to_i
      @updates = @updates.offset(@offset).limit(@count)
      @offset += @count
    else
      @updates = @updates.limit(DEFAULT_RESULTS_PER_PAGE)
      @count = DEFAULT_RESULTS_PER_PAGE
      @offset = DEFAULT_RESULTS_PER_PAGE
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def filtering_params
    params.slice :category, :identity
  end

end
