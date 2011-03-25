xml.instruct!
xml.Response do
  if ( flash.blank? )
    xml.Play "http://concertphone.timreganporter.com/welcome.mp3"
  else flash.each do |name, msg|
      xml.Say msg
    end
  end
  xml.Gather( :action => @gather_action, :numDigits => 5 ) do
    xml.Say "Please enter a 5-digit zip code for concerts in your area."
  end
end