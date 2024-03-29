class ImportedUpdate < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :identity

  def has_media?
    media_url != nil
  end

  def create_post
    post = Post.new \
      user: user,
      category: category,
      text: text
    if has_media?
      post.asset = Asset.create user: user
      AssetWorker.perform_async post.asset.id, media_url
    end
    post.move_to_front
    post.save
  end
end
