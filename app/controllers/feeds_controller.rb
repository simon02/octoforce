class FeedsController < ApplicationController

  def index
    set_list
    @feeds = @list.feeds
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      body, ok = SuperfeedrEngine::Engine.subscribe(@feed, {:retrieve => true})
      if !ok
        redirect_to @feed, notice: "Feed was successfully created but we could not subscribe: #{body}"
      else
        feed.update active: true
        if body
          @feed.notified JSON.parse(body)
        end
        redirect_to @feed, notice: 'Feed was successfully created and subscribed!'
      end
    else
      render :new
    end
  end

  def destroy
    set_feed
    set_list
    if @feed.destroy
      flash[:success] = "Feed has been removed."
    end
    redirect_to list_feeds_url(@list)
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def feed_params
    params.require(:feed).permit(:title, :url, :user_id, :list_id)
  end

end
