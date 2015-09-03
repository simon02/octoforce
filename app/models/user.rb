class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :updates, dependent: :destroy
  has_many :posts, dependent: :destroy
  after_create :setup_user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  def time_zone
    return "+02:00"
  end

  def bitly_client
    return nil if self.bitly_login.nil? || self.bitly_api_key.nil?
    @bitly_client ||= Bitly.new(self.bitly_login, self.bitly_api_key)
  end

  private

  def setup_user
    return unless self.lists.empty?
    self.lists.create name: "Blog Posts"
    self.lists.create name: "Quotes"
    self.lists.create name: "Promotion"
    self.lists.create name: "Curated Content"
    self.lists.create name: "Fun Stuff"
  end

end
