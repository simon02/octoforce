class PostsController < ApplicationController

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update post_params
    @post.save
    redirect_to list_path(@post.list)
  end

  def post_params
    params.require(:post).permit(:text, :image)
  end

end
