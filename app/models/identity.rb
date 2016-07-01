class Identity < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :timeslots
  has_many :social_media_posts, dependent: :destroy
  has_many :updates, dependent: :destroy
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  scope :filter_by_provider, -> (provider) { where('provider = ?', provider)}

  FACEBOOK_PROFILE = 'facebook'
  FACEBOOK_PAGE = 'facebook_page'
  FACEBOOK_GROUP = 'facebook_group'
  TWITTER = 'twitter'
  GITHUB = 'github'
  INSTAGRAM = 'instagram'
  LINKEDIN = 'linkedin'

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    create_identity = identity.nil?
    identity = create(uid: auth.uid, provider: auth.provider) if create_identity
    identity.accesstoken = auth.credentials.token
    identity.secrettoken = auth.credentials.secret
    identity.refreshtoken = auth.credentials.refresh_token
    identity.name = auth.info.name
    identity.email = auth.info.email
    identity.nickname = auth.info.nickname || auth.info.name
    identity.image = auth.info.image
    identity.phone = auth.info.phone
    identity.urls = (auth.info.urls || "").to_json
    identity.save
    return identity, create_identity
  end

  def client
    return @client if @client
    case self.provider
    when 'facebook', 'facebook_page', 'facebook_group'
      @client = Koala::Facebook::API.new(self.accesstoken)
    when 'github'
      @client = Github.client(accesstoken: self.accesstoken)
    when 'google'
      @client = GoogleAppsClient.client(accesstoken: self)
    when 'instagram'
      @client = Instagram.client(accesstoken: self.accesstoken)
    when 'twitter'
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_APP_ID']
        config.consumer_secret     = ENV['TWITTER_APP_SECRET']
        config.access_token        = self.accesstoken
        config.access_token_secret = self.secrettoken
      end
    end
  end

  def subname
    (self.provider == 'twitter' ? '@' : '') + self.nickname
  end

end
