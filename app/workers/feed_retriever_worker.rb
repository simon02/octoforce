class FeedRetrieverWorker
  include Sidekiq::Worker

  def perform feed_id, retrieve_past_content = false
    feed = Feed.find_by id: feed_id
    return if feed.nil?
    body, ok = SuperfeedrEngine::Engine.retrieve feed
    if ok && body
      response = JSON.parse(body)
      feed.update title: response['title'] if response['title']
      feed.notified JSON.parse(body) if retrieve_past_content
    end
  end

end
