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

  def filter_link_contains element, value, params = {}
    element_name = element.class.name.underscore.to_sym
    params = params.symbolize_keys
    if params.has_key? element_name
      val = params[element_name]
      return val.is_a?(Array) ? val.include?(value) : val == value
    end
    false
  end

  def filter_link_params element, value, params = {}
    params = params.clone.symbolize_keys
    element_name = element.class.name.underscore.to_sym
    if filter_link_contains element, value, params
      if params[element_name].is_a?(Array)
        params[element_name].delete value
      else
        params.delete element_name
      end
      return params
    elsif params.has_key? element_name
      filter = params[element_name]
      params[element_name] = ([filter] << value).flatten
      return params
    else
      return params.merge "#{element_name}": value
    end
  rescue
    params
  end

  def transform_filter_couple filter
    name = filter[0]
    value = filter[1]
    case name
    when 'category'
      category = Category.find(value)
      { name: category.name, link: filter_link_params(category,value,params) }
    when 'identity'
      identity = Identity.find(value)
      { name: identity.subname, link: filter_link_params(identity,value,params) }
    else
      nil
    end
  end

  def filter_links
    result = []
    return result unless defined? filter_keys
    params.slice(*filter_keys).each { |k,v| [v].flatten.each { |vv| result << [k,vv]  } }
    result
  end

end
