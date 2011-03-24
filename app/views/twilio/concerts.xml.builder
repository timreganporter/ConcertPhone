xml.instruct!
xml.Response do
  if flash.each do |name, msg|
      xml.Say msg
      xml.Pause
    end
  end
  xml.Say "Upcoming concerts in #{@city}"
  xml.Pause
  xml.Gather( :action => @gather_action, :numDigits => 2 ) do
    @concerts.each_with_index do |concert, index|
      xml.Say "#{concert['performance'][0]['displayName']}. Press #{index + 1} for more information."
      xml.Pause
    end
    xml.Say "Press 0 to lookup another city."
  end
end

