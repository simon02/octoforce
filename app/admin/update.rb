ActiveAdmin.register Update do
  # permit_params :email, :password, :password_confirmation
  config.sort_order = 'timestamp'

  scope :published
  scope("scheduled", default: true) { |scope| scope.published(false) }

  index do
    now = Time.zone.now
    selectable_column
    id_column
    column :text
    column :has_media?
    column :user_id do |c|
      link_to c.user_id, admin_user_path(c.user_id)
    end
    column("account") { |c| c.identity.subname }
    column("provider") { |c| c.identity.provider }
    column :scheduled_at do |c|
      if c.scheduled_at
        time_in_words = time_ago_in_words c.scheduled_at
        c.scheduled_at < now ? "#{time_in_words} ago" : "in #{time_in_words}"
      else
        ''
      end
    end
    column :published_at do |c|
      if c.published_at
        time_in_words = time_ago_in_words c.published_at
        c.published_at < now ? "#{time_in_words} ago" : "in #{time_in_words}"
      else
        ''
      end
    end
    # column("timestamp", sortable: 'scheduled_at') do |c|
    #   time = c.published ? c.published_at : c.scheduled_at
    #   time_in_words = time_ago_in_words time
    #   time < now ? "#{time_in_words} ago" : "in #{time_in_words}"
    # end
    actions
  end

  filter :text
  filter :published_at
  filter :scheduled_at
  filter :user_id, as: :select, collection: lambda { User.all.map { |u| [u.email, u.id] } }
  filter :identity_id, as: :select, collection: lambda { Identity.all.map { |i| ["#{i.subname} - #{i.provider}", i.id] } }
  filter :"identity_name"
  filter :"identity_provider", as: :select, collection: lambda { Identity.uniq.pluck(:provider) }

  # form do |f|
  #   f.inputs "Admin Details" do
  #     f.input :email
  #     f.input :password
  #     f.input :password_confirmation
  #   end
  #   f.actions
  # end

  controller do

    def scoped_collection
      super.includes :identity
    end

    def format_timestamp time, now = Time.zone.now
    end

  end

end
