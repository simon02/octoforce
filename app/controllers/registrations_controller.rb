class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :onboarding
  layout :check_onboarding

  def update_resource(resource, params)
    if resource.encrypted_password.blank? # || params[:password].blank?
      resource.email = params[:email] if params[:email]
      if !params[:password].blank? && params[:password] == params[:password_confirmation]
        logger.info "Updating password"
        resource.password = params[:password]
        resource.save
      end
      if resource.valid?
        resource.update_without_password(params)
      end
    else
      resource.update_with_password(params)
    end
  end

  private

  def check_onboarding
    current_user.onboarding_active ? 'onboarding' : 'application'
  end

end
