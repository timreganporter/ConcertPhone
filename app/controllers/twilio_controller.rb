require "twiliolib"

# TODO: move to YAML file, add config loader to project
# Twilio Config
ACCOUNT_SID = "AC699a4edd9c7cc6f193d6ac762ee8d78a"
ACCOUNT_TOKEN = "205119a7eef0444bcfbf6cebb7cfeb06"
API_VERSION = "2010-04-01"
BASE_URL = "http://concertphone.timreganporter.com/twilio"
CALLER_ID = "4155992671"
#CALLER_PIN only needed to send using sandbox number.
#CALLER_PIN = "3174-2244"

# Yahoo PlaceFinder API for looking up longitude and latitude by zip
ZIP_LOOKUP_URL = "http://where.yahooapis.com/geocode"
SK_LOCATION_URL = "http://api.songkick.com/api/3.0/search/locations.json"
SK_API_KEY = "EaGG71UXrBbjjRWE"
SK_RESULTS = 10

class TwilioController < ApplicationController

  def index

  end

  def welcome
    @gather_action = BASE_URL + "/lookup.xml"
    respond_to do |format|
      format.xml
    end
  end

  def lookup
    location = get_coordinates( params[:Digits] )
    concerts = get_concerts( location['latitude'], location['longitude'] )
    session[:concerts] = concerts
    redirect_to :action => :concerts, :format => :xml
  end

  def concerts
    @gather_action = BASE_URL + "/details.xml"
    @concerts = session[:concerts]
    @city = session[:city]
    # TODO: default format?
    respond_to do |format|
      format.xml
    end
  end

  def details
    if params[:Digits] == '0'
      redirect_to :action => :welcome, :format => :xml
      return
    end
    @gather_action = BASE_URL + "/tickets.xml"
    # TODO: error handling if concert or session not found
    concerts = session[:concerts]
    @concert = concerts[params[:Digits].to_i - 1]
    session[:concert] = @concert
    logger.debug "concert: #{@concert}"
    respond_to do |format|
      format.xml
    end
  end

  def tickets
    if params[:Digits] == '0'
      redirect_to :action => :concerts, :format => :xml
      return
    end
    @concert = session[:concert]
    d = {
        'From'  => CALLER_ID,
        'To'    => params[:Digits],
        'Body'  => "#{ @concert['performance'][0]['displayName'] } Concert Info:\n#{@concert['uri']}"
    }
    begin
      account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)
      resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages", "POST", d)
      logger.info "code: #{resp.code}, body: #{resp.body}"
      resp.error! unless resp.kind_of? Net::HTTPSuccess
    rescue StandardError => e
      flash[:error] = "There's been a problem"
      logger.debug "Error: #{ e }, d: #{ d } "
      redirect_to :action => :welcome
      return
    end
    flash[:notice] = "Text message sent. Thank you."
    redirect_to :action => :concerts, :format => :xml
  end

  protected

  # TODO make a proper class (non-AR model) for this
  def get_coordinates( zip )
    result = HTTParty::get( ZIP_LOOKUP_URL, :query => { :q => zip, :flags => "j" })
    # must be a cleaner way to do this
    result.first[1]["Results"][0]
  end

  def get_concerts( latitude, longitude )
    result = HTTParty::get( SK_LOCATION_URL, :query => { :location => "geo:#{latitude},#{longitude}", :apikey => SK_API_KEY } )
    result = result.first[1]['results']['location'][0]['metroArea']
    # now that I've added this, inconsistent with variables/methods. Make some models!
    metro_area_id = result['id']
    session[:city] = result['displayName']
    # just hardcoding the URL for now since id is not in a query param
    concerts = HTTParty::get( "http://api.songkick.com/api/3.0/metro_areas/#{metro_area_id}/calendar.json", :query => { :apikey => SK_API_KEY, :per_page => SK_RESULTS } )
    concerts.first[1]['results']['event']
  end

end