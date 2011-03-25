module ApplicationHelper

  def format_time(time)
    if !time.blank?
      time = time.gsub(/:\d\d$/,'').split(':')
      hour = time[0].to_i
      ", starting at #{ hour % 12 }:#{ time[1] } #{ hour < 12 ? "a.m." : "p.m." }"
    end
  end

  def format_city(city)
    if !city.blank?
      city = city.gsub(/, (\w)*$/, '')
      city = city.gsub(/^SF/,'San Francisco')
      ", in #{city}"
    end
  end

end
