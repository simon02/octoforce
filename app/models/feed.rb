class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  validates_presence_of :user, :list

  def secret
    Digest::MD5.hexdigest(created_at.to_s)
  end

  def notified params
    update_attributes(:status => params["status"]["http"])

    params['items'].each do |i|
      post = Post.new user: user, text: "#{i['title']} #{i['permalinkUrl']}"
      list.move_to_front(post) if list
    end
  end
end
