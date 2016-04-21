class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :onboarding

  def instagram
    generic_callback( 'instagram' )
  end
  def facebook
    generic_callback( 'facebook' )
  end
  def google_oauth2
    generic_callback( 'google_oauth2' )
  end
  def twitter
    generic_callback( 'twitter' )
  end
  def facebook_page
    auth = env["omniauth.auth"]
    @client = Koala::Facebook::API.new(auth.credentials.token)
    pages = @client.get_connections("me","accounts?fields=name,id,picture,access_token")
    pages.each do |page|
      identity = current_user.identities.create uid: page["id"], provider: auth.provider, accesstoken: page["access_token"], name: page["name"], nickname: page["name"]
      begin
        identity.image = page["picture"]["data"]["url"]
        identity.save
      rescue
      end
    end
    redirect_to identities_url
  end
  def facebook_group
    auth = env["omniauth.auth"]
    @client = Koala::Facebook::API.new(auth.credentials.token)
    groups = @client.get_connections("me","groups?fields=name,id,picture,email")
    groups.each do |group|
      identity = current_user.identities.create uid: group["id"], provider: auth.provider, accesstoken: auth.credentials.token, name: group["name"], nickname: group["name"]
      begin
        identity.image = group["picture"]["data"]["url"]
        identity.save
      rescue
      end
    end
    redirect_to identities_url
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
      redirect_to @user.identities.count == 1 ? library_url : identities_url
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
