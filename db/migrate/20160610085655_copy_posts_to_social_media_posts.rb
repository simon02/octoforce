class CopyPostsToSocialMediaPosts < ActiveRecord::Migration
  def up
    Post.all.each do |post|
      next unless post.user
      post.user.identities.each do |id|
        smp = SocialMediaPost.create \
          post_id: post.id,
          identity_id: id.id,
          text: post.text,
          asset_id: post.asset_id,
          position: post.position
        if id.provider != 'twitter' && post.link
          smp.update link_id: post.link.id
        end
      end
    end
  end

  def down
    SocialMediaPost.all.each do |smp|
      post = smp.post
      post.update \
        text: smp.text,
        asset_id: smp.asset_id,
        position: smp.position
      if link = Link.find_by(id: smp.link_id)
        link.update post_id: smp.post_id
      end
    end
  end
end
