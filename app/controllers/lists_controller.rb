class ListsController < ApplicationController

  def index
    @lists = current_user.lists
    @list = List.new
  end

  def show
    @list = List.find(params[:id])
    @post = Post.new
  end

  def create
    list = List.create list_params
    list.user = current_user
    list.save
    redirect_to lists_url
  end

  def add_post
    post = Post.new text: params[:text]
    post.asset = Asset.new(media: params[:asset], user: current_user) if params[:asset]
    post.user = current_user
    post.save
    List.find(params[:list_id]).move_to_front post

    redirect_to list_url(params[:list_id])
  end

  def batch_add_post
    list = List.find(params[:list_id])
    params[:text].split(/\r?\n\r?\n/).reverse.each do |text|
      post = Post.create user: current_user, text: text
      list.move_to_front post
    end
    redirect_to list_url(list.id)
  end

  def remove_post
    post = Post.find(params[:post_id])
    if post.user_id == current_user.id
      post.destroy
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
