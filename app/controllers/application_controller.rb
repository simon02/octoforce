class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  impersonates :user

  before_filter :authenticate
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate
    unless ENV['HTTP_AUTH_USERNAME'].blank? or ENV['HTTP_AUTH_PASSWORD'].blank?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_AUTH_USERNAME'] && password == ENV['HTTP_AUTH_PASSWORD']
      end
    else
      authenticate_user!
    end
  end

  def onboarding options = {}, &block
    if current_user && current_user.onboarding_active
      redirect_to :"welcome_step#{current_user.onboarding_step || 0}", options
    elsif block
      block.call options
    end
  end

  def intercom_event event_name, metadata = {}
    @intercom ||= init_intercom
    @intercom.events.create(
      event_name: event_name,
      created_at: Time.zone.now.to_i,
      email: current_user.email,
      metadata: metadata
    )
  rescue
    # log the intercom error...
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end

  private

  def paging ar_relation, count, offset
    count = count.to_i
    offset = offset.to_i
    [ar_relation.offset(offset).limit(count), count, offset + count]
  end

  def init_intercom
    Intercom::Client.new(app_id: ENV["INTERCOM_APP_ID"], api_key: ENV["INTERCOM_API_KEY"])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :timezone
    devise_parameter_sanitizer.for(:account_update) << :timezone
  end

  def redirect_with_param path, options = {}
    if params[:redirect]
      uri = URI.parse(params[:redirect])
      path = "#{uri.path}?#{uri.query}"
    end
    redirect_to path, options
  end

  # execute a block with a different format (ex: an html partial while in an ajax request)
  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end

end
