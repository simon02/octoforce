class MailchimpWorker
  include Sidekiq::Worker

  TYPE_BETA_SUBSCRIPTION = 1

  def perform type, options = {}
    gibbon = Gibbon::Request.new
    case type
    when TYPE_BETA_SUBSCRIPTION
      beta_subscription gibbon, options
    end
  end

  def beta_subscription gibbon, options
    email = options["email"]
    md5 = Digest::MD5.hexdigest email
    gibbon.lists('80143134c7').members(md5).upsert(
      body: {
        email_address: email,
        status: "subscribed",
        interests: {
          "1174b18198": true
        }
      }
    )
  end

end
