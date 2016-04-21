class TwitterMentionsWorker
  include Sidekiq::Worker

  def perform identity_id = nil
    if identity_id.nil?
      Identity.filter_by_provider('twitter').each { |identity| TwitterMentionsWorker.perform_async identity.id }
    else
      perform_with_identity identity_id
    end
  end

  def perform_with_identity identity_id
    identity = Identity.find_by id: identity_id
    return if identity.nil? || identity.provider != 'twitter'
    calculate_mentions identity
  end

  def calculate_mentions identity
    since_id = (identity.last_checked || 1).to_i
    mentions = get_mentions identity.client, since_id
    first_id = mentions.first.id unless mentions.empty?
    # We keep track of the updates that need to be altered so we can execute this in one statement
    updates = Hash.new(0)
    5.times do
      break if mentions.empty?
      mentions.each do |mention|
        next unless mention.in_reply_to_status_id? || mention.quote?
        id = mention.in_reply_to_status_id? ? mention.in_reply_to_status_id : mention.quoted_status.id
        update = Update.find_by response_id: id.to_s
        updates[update.id] += 1 if update
      end
      # only works on 64-bit environments (local dev pc + heroku are OK)
      mentions = get_mentions identity.client, since_id, max_id: (mentions.last.id - 1)
    end
    # Should really be in a DB transaction
    updates.each do |id, increment|
      u = Update.find id
      u.increment! :comments, increment
    end
    identity.update last_checked: first_id.to_s if first_id ||= false
  end

  def get_mentions client, since_id = 1, options = {}
    options.merge! count: 200, since_id: since_id, trim_user: true
    client.mentions_timeline options
  end
end
