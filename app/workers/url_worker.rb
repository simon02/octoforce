class UrlWorker
  include Sidekiq::Worker

  def perform update_id
    update = Update.find update_id
    bitly = update.user.bitly_client
    update.update(text: replace_with_bitly_links(update.text, bitly)) if bitly
  end

  def replace_with_bitly_links text, bitly_client
    links = URI.extract text
    links.map! do |link|
      [link, bitly_client.shorten(link)]
    end
    links.each { |l| text.sub!(l[0], l[1].short_url)}
    text
  end

end
