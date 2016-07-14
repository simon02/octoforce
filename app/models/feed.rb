class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates_presence_of :user, :category

  def secret
    Digest::MD5.hexdigest(created_at.to_s)
  end

  def notified params
    update_attributes(:status => params["status"]["http"])

    params['items'].each do |i|
      begin
        url = i['standardLinks']['canonical'].first['href']
      rescue
        url = i['permalinkUrl']
      end
      post = Post.new user: user, category: category, text: "#{i['title']} #{url}", social_media_posts_attributes: user.identities.map { |i| { identity_id: i.id } }
      post.move_to_front
      post.save
    end
    QueueWorker.perform_async(category.id)
  end
end
