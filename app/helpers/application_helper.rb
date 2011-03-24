module ApplicationHelper
  def format_time(time)
    time = time.gsub(/:\d\d$/,'').split(':')
    hour = time[0].to_i
    "#{ hour % 12 }:#{ time[1] } #{ hour < 12 ? "a.m." : "p.m." }"
  end
end
