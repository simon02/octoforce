class FeedsController < ApplicationController

  def index
    @feeds = current_user.feeds
    @categories = current_user.categories
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.user = current_user

    if @feed.save
      body, ok = SuperfeedrEngine::Engine.subscribe(@feed, {:retrieve => false})
      if !ok
        redirect_to feeds_url, alert: "Feed was successfully created but we could not subscribe: #{body}"
      else
        @feed.update active: true
        FeedRetrieverWorker.perform_async @feed.id, params[:retrieve_content]
        redirect_to feeds_url, notice: 'Feed has been added! Currently retrieving feed title.'
      end
    else
      redirect_to feeds_url, alert: 'Feed could not be created!'
    end
  end

  def update
    feed = Feed.find params[:id]
    feed.update feed_params_edit
    if !feed.active
      body, ok = SuperfeedrEngine::Engine.subscribe(@feed, {:retrieve => false})
      if !ok
        redirect_to feeds_url, alert: "Feed updated, but could not be activated."
      else
        feed.update active: true
      end
    end
    redirect_to feeds_url, notice: "Feed has been updated."
  end

  def destroy
    set_feed
    if @feed.destroy
      flash[:success] = "Feed has been removed."
    end
    redirect_to feeds_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :url, :category_id)
  end

  def feed_params_edit
    params.require(:feed).permit(:title, :category_id)
  end

end
