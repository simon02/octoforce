ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Published Updates" do
          render partial: "admin/chart", locals: { scope: 'published' }
        end
      end
      column do
        panel "Scheduled Updates" do
          render partial: "admin/chart", locals: { scope: 'scheduled' }
        end
      end
    end

    columns do
      column do
        panel "Users" do
          render partial: "admin/chart", locals: { scope: 'users' }
        end
      end
    end

    columns do
      column do
        panel "Twitter" do
          render partial: "admin/chart", locals: { scope: 'twitter_users' }
        end
      end
      column do
        panel "Instagram" do
          render partial: "admin/chart", locals: { scope: 'instagram_users' }
        end
      end
    end
  end
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  # end # content
end
