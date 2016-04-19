ActiveAdmin.register User do

  member_action :impersonate do
    impersonate_user(resource)
    redirect_to root_path
  end

  collection_action :stop_impersonating do
    stop_impersonating_user
  end

  action_item :impersonate do
    link_to 'Impersonate', impersonate_admin_user_path(user)
  end

end
