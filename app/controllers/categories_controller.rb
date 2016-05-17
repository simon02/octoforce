class CategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @category = Category.new
    @posts = current_user.posts.filter(filtering_params)
  end

  def show
    @categories = current_user.categories
    @category = Category.find_by id: params[:id]
    @posts = @category.posts.sort_by { |p| [-p.updates.published(false).size, p.position] }
    @new_post = Post.new
    @new_category = Category.new
  end

  def reorder
    category = Category.find_by id: params[:category_id]
    ids = params["ids"]
    if category && ids.size == category.posts.size
      category.updates.destroy_all
      ids.each_with_index do |id, i|
        p = Post.find_by id: id.to_i
        p.position = i + 1
        p.save
      end
      category.reschedule 2
    else
    end
    respond_to do |f|
      f.html { redirect_to category_path(category) }
      f.json do
        mapping = category.posts.map do |p|
          time = ''
          with_format :html do
            time = render_to_string partial: "categories/scheduling_time", locals: { post: p }
          end
          [p.id, time]
        end
        render json: mapping.to_h
      end
    end
  end

  def create
    category = Category.create category_params
    category.user = current_user
    if category.save
      intercom_event 'created-category', number_of_categories: current_user.categories.count
    end

    redirect_with_param library_path, notice: "Category '#{category.name}' has been created."
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
