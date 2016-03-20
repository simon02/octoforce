module ApplicationHelper
  include Twitter::Autolink

  def flash_class(level)
    case level.to_sym
        when :notice then "alert-info"
        when :success then "alert-success"
        when :alert then "alert-warning"
        when :error then "alert-danger"
        else "alert-danger"
    end
  end

  def page_title
    @title || controller_name.gsub( /Controller/, "" ).humanize
  end

  def calculate_local_time time
    return Time.zone.now if !current_user
    tz = current_user.tzinfo
    tz.utc_to_local time
  end

  def show text
    h(text).gsub("\n", "<br>").html_safe
  end

end
