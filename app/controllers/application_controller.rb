class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    unless ENV['HTTP_AUTH_USERNAME'].blank? or ENV['HTTP_AUTH_PASSWORD'].blank?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_AUTH_USERNAME'] && password == ENV['HTTP_AUTH_PASSWORD']
      end
    else
      authenticate_user!
    end
  end

  def intercom_event event_name, metadata = {}
    @intercom ||= init_intercom
    @intercom.events.create(
      event_name: event_name,
      created_at: Time.now.to_i,
      email: current_user.email,
      metadata: metadata
    )
  rescue
    # log the intercom error...
  end

  private

  def init_intercom
    Intercom::Client.new(app_id: ENV["INTERCOM_APP_ID"], api_key: ENV["INTERCOM_API_KEY"])
  end

end
