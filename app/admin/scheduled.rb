ActiveAdmin.register_page "Scheduled" do
  content do
    @updates = Update.published(false).order(scheduled_at: :asc)

    panel "Scheduled Updates" do
      table_for @updates do
        column( "timestamp" ) { |d| "in #{time_ago_in_words d.scheduled_at}" }
        column( "text" ) { |d| d.text }
        column( "media" ) { |d| d.has_media? }
        column( "user" ) { |d| d.identity.subname }
        column( "provider" ) { |d| d.identity.provider }
        # column( "action" ) do |d|
        #   link_to "Send Message", admin_newsletter_create_message_path( list_id: d['id'] ), class: "button"
        # end
      end
    end

  end
end
