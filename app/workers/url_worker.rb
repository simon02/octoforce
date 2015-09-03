class UrlWorker
  include Sidekiq::Worker

  def perform content_item_id
    ci = ContentItem.find content_item_id
    bitly = ci.identity.user.bitly_client
    ci.update_column(:text, UrlWorker.replace_with_bitly_links(ci.text, bitly)) if bitly
  end

  def self.replace_with_bitly_links text, bitly_client
    links = URI.extract text
    links.map! do |link|
      [link, bitly_client.shorten(link)]
    end
    links.each { |l| text.sub!(l[0], l[1].short_url)}
    text
  end

end
