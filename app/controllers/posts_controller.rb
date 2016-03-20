class PostsController < ApplicationController
  load_resource :list

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update post_params
    if params[:asset]
      @post.asset = Asset.new media: params[:asset], user: current_user
      @post.save
    end
    redirect_to list_path(@post.list)
  end

  def show_bulk
    @list = List.find(params[:list_id])
    authorize! :show_bulk, @list
  end

  def bulk_preview
    regexp = /#{"\r?\n"*params[:nr_enters].to_i}/
    @list = List.find(params[:list_id])
    @posts = params[:text].split(regexp).map { |text| Post.new text: text, list: @list }
    authorize! :bulk_preview, @list
  end

  def create
    @post = Post.new text: params[:text]
    @post.asset = Asset.new(media: params[:asset], user: current_user) if params[:asset]
    @post.user = current_user
    if @post.save
      intercom_event 'post-created', number_of_posts: current_user.posts.count, contains_media: !params[:asset].nil?

      @list.move_to_front @post
      QueueWorker.perform_async(@list.id)
    end

    respond_to do |format|
      format.html { redirect_to list_url(@list) }
      format.js
    end
  end

  def create_bulk
    list = List.find(params[:list_id])
    params[:posts].to_a.reverse.each do |post|
      p = Post.create user: current_user, text: post["text"]
      list.move_to_front p
    end

    QueueWorker.perform_async(list.id)

    intercom_event 'created-posts-batch', number_of_posts: current_user.posts.count, posts_added: params[:posts].to_a.count

    redirect_to list_url(list.id)
  end

  def destroy
    post = Post.find(params[:id])
    list = post.list
    authorize! :destroy, post
    post.destroy
    QueueWorker.perform_async(list.id)
    @post_id = params[:id]

    respond_to do |format|
      format.html { redirect_to list_url(list) }
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:text)
  end

end
