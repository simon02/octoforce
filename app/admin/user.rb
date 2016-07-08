ActiveAdmin.register User do

  index do
    id_column
    column :email
    column("Scheduled") { |c| c.updates.published(false).count }
    column("Published") { |c| c.updates.published.count }
    column("Posts") { |c| c.posts.count }
    column("Categories") { |c| c.categories.count }
    column("Feeds") { |c| c.feeds.count }
    column("Identities") { |c| c.identities.count }
    column("Timeslots") { |c| c.timeslots.count }
    column :onboarding_step
    column :onboarding_active
    column :shorten_links
    column("impersonate") do |c|
      link_to "impersonate", impersonate_admin_user_path(c.id)
    end

  end

  member_action :impersonate do
    impersonate_user(resource)
    redirect_to root_path
  end

  collection_action :stop_impersonating do
    stop_impersonating_user
    redirect_to collection_path, notice: "Stopped impersonation!"
  end

  action_item :impersonate, only: :show do
    link_to 'Impersonate', impersonate_admin_user_path(user)
  end

end
