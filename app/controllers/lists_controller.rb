class ListsController < ApplicationController
  load_and_authorize_resource

  def index
    @list = List.new
    redirect_to list_url(@lists.first)
  end

  def show
    @lists = current_user.lists
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

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def post_params
    params.require(:post).permit(:list_id, :text, :asset)
  end

end
