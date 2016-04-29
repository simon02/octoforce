class LibraryController < ApplicationController

  def index
    @sorted_posts = current_user.posts.filter(filtering_params).sort_by { |post| [post.updates.scheduled.count.zero? ? 0 : -1, post.position] }
    @categories = current_user.categories.includes(:posts)
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
