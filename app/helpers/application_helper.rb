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

  def darken_color(hex_color, amount=0.4)
    hex_color = hex_color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = (rgb[0].to_i * amount).round
    rgb[1] = (rgb[1].to_i * amount).round
    rgb[2] = (rgb[2].to_i * amount).round
    "#%02x%02x%02x" % rgb
  end

  # Amount should be a decimal between 0 and 1. Higher means lighter
  def lighten_color(hex_color, amount=0.6)
    hex_color = hex_color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
    rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
    rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
    "#%02x%02x%02x" % rgb
  end

end
