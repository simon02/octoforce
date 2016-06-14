class LibraryController < ApplicationController

  DEFAULT_RESULTS_PER_PAGE = 30

  def add_content
    @categories = current_user.categories.includes(:posts)
    @post = Post.new
    current_user.identities.each { |identity| @post.social_media_posts.build identity: identity }
  end

  def index
    posts = current_user.posts.filter(filtering_params).order(created_at: :desc)
    @sorted_posts, @count, @offset = paging posts, params['count'] || DEFAULT_RESULTS_PER_PAGE, params['offset'] || 0
    @categories = current_user.categories.includes(:posts)
    @filters = filtering_params
    respond_to do |format|
      format.html
      format.js
    end
  end

  def filter
    @posts = current_user.posts.filter(filtering_params)
    respond_to do |format|
      format.js
    end
  end

  private

  def filtering_params
    params.slice :category, :q
  end

end
