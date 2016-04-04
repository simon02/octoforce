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
      post = Post.new user: user, text: "#{i['title']} #{i['permalinkUrl']}"
      category.move_to_front(post) if category
    end
  end
end
