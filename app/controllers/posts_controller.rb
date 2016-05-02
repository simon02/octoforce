class PostsController < ApplicationController
  load_resource :category
  skip_before_filter :onboarding, only: [:create]

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      intercom_event 'post-created', number_of_posts: current_user.posts.count, contains_media: @post.has_media?
      flash[:success] = "Post has been added to #{@post.category.name}"

      @post.move_to_front
      QueueWorker.perform_async(@post.category.id)
    else
      flash[:error] = "Failed to add post to #{@post.category.name}"
    end

    respond_to do |format|
      format.html do
        redirect_with_param category_url(@post.category)
      end
      format.js
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.update post_params
    redirect_with_param category_path(@post.category), notice: 'Post was updated.'
  end

  def show_bulk
    @category = Category.find(params[:category_id])
    authorize! :show_bulk, @category
  end

  def bulk_preview
    regexp = /#{"\r?\n"*params[:nr_enters].to_i}/
    @category = Category.find(params[:category_id])
    @posts = params[:text].split(regexp).map { |text| Post.new text: text, category: @category }
    authorize! :bulk_preview, @category
  end

  def create_bulk
    category = Category.find(params[:category_id])
    params[:posts].to_a.reverse.each do |post|
      p = Post.create user: current_user, text: post["text"]
      category.move_to_front p
    end

    QueueWorker.perform_async(category.id)

    intercom_event 'created-posts-batch', number_of_posts: current_user.posts.count, posts_added: params[:posts].to_a.count

    redirect_to category_url(category.id)
  end

  def destroy
    post = Post.find(params[:id])
    category = post.category
    authorize! :destroy, post
    post.destroy
    QueueWorker.perform_async(category.id)
    @post_id = params[:id]

    respond_to do |format|
      format.html { redirect_to category_url(category) }
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:text, :category_id, :asset_id)
  end

end
