class ContentItem < ActiveRecord::Base
  belongs_to :identity
  belongs_to :post
  belongs_to :asset
  validates_presence_of :text

  after_save :replace_links

  private

  def replace_links
    UrlWorker.perform_async(self.id) unless URI.extract(self.text).empty?
  end

end
