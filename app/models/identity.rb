class Identity < ActiveRecord::Base
  belongs_to :user
  has_many :schedules, dependent: :nullify
  has_many :updates, dependent: :destroy
  after_save :setup
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity.accesstoken = auth.credentials.token
    identity.secrettoken = auth.credentials.secret
    identity.refreshtoken = auth.credentials.refresh_token
    identity.name = auth.info.name
    identity.email = auth.info.email
    identity.nickname = auth.info.nickname
    identity.image = auth.info.image
    identity.phone = auth.info.phone
    identity.urls = (auth.info.urls || "").to_json
    identity.save
    identity
  end

  def client
    return @client if @client
    case self.provider
    when 'facebook'
      @client = Facebook.client(accesstoken: self.accesstoken)
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

  private

  def setup
    self.schedules.create name: "Schedule for #{self.nickname}", user: self.user
  end

end
