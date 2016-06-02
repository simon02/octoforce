class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :onboarding

  def instagram
    generic_callback( 'instagram' )
  end
  def facebook
    generic_callback( 'facebook' )
  end
  def facebook_page
    generic_callback( 'facebook' )
  end
  def google_oauth2
    generic_callback( 'google_oauth2' )
  end
  def twitter
    generic_callback( 'twitter' )
  end


  def generic_callback( provider )
    @identity, created = Identity.find_for_oauth env["omniauth.auth"]

    @user = @identity.user || current_user
    if @user.nil?
      @user = User.create( email: @identity.email || "" )
      @identity.update_attribute( :user_id, @user.id )
    end

    if @user.email.blank? && @identity.email
      @user.update_attribute( :email, @identity.email)
    end

    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id )
      # This is because we've created the user manually, and Device expects a
      # FormUser class (with the validations)
      @user = FormUser.find @user.id
      sign_in @user
      set_flash_message(:success, created ? :success : :authenticated, kind: provider.capitalize) if is_navigational_format?
      if @user.onboarding_active
        redirect_to :welcome_step2
      else
        redirect_to identities_url
      end
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
