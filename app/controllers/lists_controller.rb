class ListsController < ApplicationController

  def index
    @lists = current_user.lists
    @list = List.new
    redirect_to list_url(@lists.first)
  end

  def show
    @lists = current_user.lists
    @list = List.find_by(id: params[:id]) || List.new
    @new_post = Post.new
    @new_list = List.new
  end

  def create
    list = List.create list_params
    list.user = current_user
    if list.save
      intercom_event 'created-list', number_of_lists: current_user.lists.count
    end

    redirect_to list_url(list)
  end

  def add_post
    post = Post.new text: params[:text]
    post.asset = Asset.new(media: params[:asset], user: current_user) if params[:asset]
    post.user = current_user
    if post.save
      intercom_event 'post-created', number_of_posts: current_user.posts.count, contains_media: !params[:asset].nil?
    end

    List.find(params[:list_id]).move_to_front post
    QueueWorker.perform_async(params[:list_id])

    redirect_to list_url(params[:list_id])
  end

  def batch_add_post
    list = List.find(params[:list_id])
    params[:text].split(/\r?\n\r?\n/).reverse.each do |text|
      post = Post.create user: current_user, text: text
      list.move_to_front post
    end

    QueueWorker.perform_async(list.id)

    intercom_event 'created-posts-batch', number_of_posts: current_user.posts.count, posts_added: params[:text].split(/\r?\n\r?\n/).count

    redirect_to list_url(list.id)
  end

  def remove_post
    post = Post.find(params[:post_id])
    if post.user_id == current_user.id
      post.destroy
      QueueWorker.perform_async(post.list.id)
    else
      flash[:error] = "Invalid operation"
    end
    redirect_to list_url id: params[:list_id]
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def post_params
    params.require(:post).permit(:list_id, :text, :asset)
  end

end
