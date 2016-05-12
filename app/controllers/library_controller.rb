class LibraryController < ApplicationController

  def add_content
    @categories = current_user.categories.includes(:posts)
  end

  def index
    @sorted_posts = current_user.posts.includes(:asset).filter(filtering_params).order(created_at: :desc)
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
