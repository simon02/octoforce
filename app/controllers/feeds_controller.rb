class FeedsController < ApplicationController

  def index
    set_category
    @feeds = @category.feeds
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
    set_category
    if @feed.destroy
      flash[:success] = "Feed has been removed."
    end
    redirect_to category_feeds_url(@category)
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

  # Only allow a trusted parameter "white category" through.
  def feed_params
    params.require(:feed).permit(:title, :url, :user_id, :category_id)
  end

end
