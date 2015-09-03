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
    if params[:identity_ids]
      post = Post.new
      params[:identity_ids].each do |id|
        identity = Identity.find(id)
        unless identity.user_id == current_user.id # no hacking!
          puts "=====--- --==== NO HACKING"
          redirect_to list_url(params[:list_id])
        end
        content_item = ContentItem.new text: params[:text], identity: identity
        content_item.asset = Asset.new(media: params[:asset], user: current_user) if params[:asset]
        post.content_items << content_item
      end
      post.user = current_user
      post.save
      List.find(params[:list_id]).add_to_front post
    else
      set_flash_message :error, "You need to select at least one social account"
    end

    redirect_to list_url(params[:list_id])
  end

  def batch_add_post
    identity = current_user.identities.first
    list = List.find(params[:list_id])
    params[:text].split(/\r?\n\r?\n/).each do |text|
      post = Post.create user: current_user
      post.content_items.create text: text
      post.save
      list.add_to_front post
    end
    redirect_to list_url(list.id)
  end

  def remove_post
    post = Post.find(params[:post_id])
    puts post.user.inspect
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
    params.require(:post).permit(:identity_ids, :list_id, :text, :image)
  end

end
