class AjaxController < ApplicationController
  layout false


  def scraper link = nil
    link ||= params[:link]
    # Could be prettier... and better
    link = "http://#{link}" unless link[/\Ahttps?:\/\//]
    begin
      @resource = LinkThumbnailer.generate link, image_limit: 5
    rescue => e
      render :no_content
    end
  end

end
