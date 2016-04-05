class FeedsController < ApplicationController

  def index
    @feeds = current_user.feeds
    @categories = current_user.categories
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      body, ok = SuperfeedrEngine::Engine.subscribe(@feed, {:retrieve => false})
      if !ok
        redirect_to feeds_url, notice: "Feed was successfully created but we could not subscribe: #{body}"
      else
        @feed.update active: true
        FeedRetrieverWorker.perform_async @feed.id, params[:retrieve_content]
        redirect_to feeds_url, notice: 'Feed has been added! Currently retrieving feed title.'
      end
    else
      render :new
    end
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

  # Only allow a trusted parameter "white category" through.
  def feed_params
    params.require(:feed).permit(:title, :url, :user_id, :category_id)
  end

end
