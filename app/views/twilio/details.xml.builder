xml.instruct!
xml.Response do
  xml.Say(
    "#{@concert['performance'][0]['displayName']} is playing on
    #{ format_date(@concert['start']['date']) }, at #{@concert['venue']['displayName']}
    #{ format_city(@concert['location']['city']) }
    #{ format_time(@concert['start']['time']) }",
    :voice => "woman")
  xml.Pause
  xml.Gather( :action => @gather_action, :numDigits => 10 ) do
    xml.Say( "To send your cell phone a URL for tickets, enter your 10-digit phone number.
      Or enter 0 to return to concert listings.")
  end
end
