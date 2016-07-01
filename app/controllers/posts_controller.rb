class PostsController < ApplicationController
  load_resource :category

  def new
  end

  def edit
    @title = 'Edit this post'
    @post = Post.find(params[:id])
    @categories = current_user.categories.includes(:posts)
  end

  def create
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      intercom_event 'post-created', number_of_posts: current_user.posts.count, contains_media: @post.has_media?
      flash[:success] = "Post has been added to #{@post.category.name}"

      @post.social_media_posts.update_all position: @post.category.first_position
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
    # if link is not set in params, it should be destroyed
    l = { link_attributes: { _destroy: 1 } }
    @post.update l.merge(post_params)
    QueueWorker.perform_async(@post.category.id)
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

  # Forms return social media post specific parameters on the parent post
  def split_in_social_media_posts
    temp_params = params["post"].symbolize_keys
    p = temp_params.slice :id, :category_id
    temp_params[:identity_ids].delete_if(&:empty?) if temp_params[:identity_ids].size != 1
    p[:social_media_posts_attributes] = clone_params_to_ids temp_params[:identity_ids], temp_params.slice(asset_id, text)
    p
  end

  def clone_params_to_identity_ids ids, params = {}
    ids.map { |id| params.deep_dup.merge(identity_id: id) }
  end

  def post_params
    params.require(:post).permit(
      :id,
      :category_id,
      :text,
      :asset_id,
      social_media_posts_attributes: [
        :id,
        :identity_id,
        :_destroy
      ],
      link_attributes: [
        :id,
        :url,
        :caption,
        :title,
        :description,
        :image_url
      ]
    )
  end

end
