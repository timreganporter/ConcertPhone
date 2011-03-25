xml.instruct!
xml.Response do
  if ( flash.blank? )
    xml.Say "Welcome to Concert Phone! Powered by Twilio and SongKick."
  else flash.each do |name, msg|
      xml.Say msg
    end
  end
  xml.Gather( :action => @gather_action, :numDigits => 5 ) do
    xml.Say "Please enter a 5-digit zip code for concerts in your area."
  end
end