class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :timeslots, through: :schedules
  has_many :updates, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :feeds, dependent: :destroy
  has_many :csvs, dependent: :destroy
  after_create :setup_user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  def tzinfo
    TZInfo::Timezone.get(timezone)
  end

  def bitly_client
    return nil if self.bitly_login.nil? || self.bitly_api_key.nil?
    @bitly_client ||= Bitly.new(self.bitly_login, self.bitly_api_key)
  end

  def providers
    identities.pluck(:provider).map { |name| name.split('_').first }.uniq
  end

  private

  def setup_user
    if self.schedules.empty? && self.user
      self.schedules.create name: "Schedule for #{self.nickname}", user: self.user
    end
    return unless self.categories.empty?
    self.categories.create name: "Blog Posts"
    self.categories.create name: "Quotes"
    self.categories.create name: "Promotion"
    self.categories.create name: "Curated Content"
    self.categories.create name: "Fun Stuff"
  end

end
