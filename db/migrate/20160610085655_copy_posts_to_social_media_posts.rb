class CopyPostsToSocialMediaPosts < ActiveRecord::Migration
  def up
    Post.all.each do |post|
      next unless post.user
      post.user.identities.each do |id|
        smp = SocialMediaPost.create \
          post_id: post.id,
          identity_id: id.id,
          position: post.position
      end
    end
  end

  def down
    Post.all.each do |post|
      post.update position: post.social_media_posts.map(&:position).min || 100
    end
  end
end
