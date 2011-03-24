# hacktastic, redo
xml.instruct!
xml.Response do
  xml.Say(
    "#{@concert['performance'][0]['displayName']} is playing on
    #{@concert['start']['date']}, at #{@concert['venue']['displayName']}
    #{ if !@concert['location']['city'].blank?
      ", in #{@concert['location']['city'].gsub(/, (\w)*$/, '')}"
    end}
    #{ if !@concert['start']['time'].blank?
        ", starting at #{ format_time(@concert['start']['time'])}"
    end}.",
    :voice => "woman")
  xml.Pause
  xml.Gather( :action => @gather_action, :numDigits => 10 ) do
    xml.Say( "To send your cell phone a URL for tickets, enter your 10-digit phone number.
      Or enter 0 to return to concert listings.")
  end
end
