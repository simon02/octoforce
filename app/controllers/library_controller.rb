class LibraryController < ApplicationController

  def index
    @posts = current_user.posts.filter(filtering_params)
    @categories = current_user.categories
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
