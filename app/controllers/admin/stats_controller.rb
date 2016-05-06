class Admin::StatsController < ApplicationController
  before_filter :authenticate_admin_user!

  def stats
    if params[:scope].blank?
      render :json => { :errors => "scope not set" }, :status => 422
    elsif params[:scope] == 'scheduled'
      ret = Update.published(false).group_by_day :scheduled_at
      render json: ret
    elsif params[:scope] == 'published'
      ret = Update.published.where('published_at >= ?', Time.zone.now - 1.month).group_by_day :published_at
      render json: ret
    else
      cls = User
      cls = Identity.where( "provider = ?", "twitter" ) if params[:scope] == 'twitter_users'
      cls = Identity.where( "provider = ?", "instagram" ) if params[:scope] == 'instagram_users'
      ret = cls.group_by_month
      render json: ret
    end
  end
end
