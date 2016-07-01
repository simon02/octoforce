class PostFacade
  attr_accessor :text, :link, :asset, :identities

  def initialize(post)
    @post = post
    @identities = []
    if smp = post.social_media_posts.first
      @text = smp.text
      @asset = smp.asset
      @link = smp.link
    end
    @identities = post.social_media_posts.map &:identity
  end

  private

  attr_reader :post

end
