class PostsController < ApplicationController

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

  def post_params
    params.require(:post).permit(:text)
  end

end
