class CategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @category = Category.new
    @posts = current_user.posts.filter(filtering_params)
  end

  def show
    @categories = current_user.categories
    @category = Category.find_by id: params[:id]
    @new_post = Post.new
    @new_category = Category.new
  end

  def create
    category = Category.create category_params
    category.user = current_user
    if category.save
      intercom_event 'created-category', number_of_categories: current_user.categories.count
    end

    redirect_to category_url(category)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def post_params
    params.require(:post).permit(:category_id, :text, :asset)
  end

  def filtering_params
    params.slice(:category)
  end
end
