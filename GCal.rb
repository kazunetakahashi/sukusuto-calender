# coding: utf-8
# Thanks to
# http://mcommit.hatenadiary.com/entry/2016/04/18/183200
# https://developers.google.com/google-apps/calendar/quickstart/ruby
# http://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/CalendarV3/
# https://mmyoji.github.io/2016/07/29/google-calendar-api-from-ruby-push-notification.html
# https://github.com/seejohnrun/ice_cube

class GCal
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'google/api_client/client_secrets'
  require 'google/apis/calendar_v3'
  require 'ice_cube'

  APPLICATION_NAME = 'sukusuto-calender'
  TIME_ZONE = 'Japan'
  # Google APIs / Google Account
  GCAL_ID = 'pe673ankt1e65kdhhus8q18hco@group.calendar.google.com'
  DIR_PATH = File.expand_path(__dir__)
  CREDENTIALS_PATH = File.join(DIR_PATH, "secret", "tokens.yaml")
  CLIENT_ID = File.join(DIR_PATH, "secret", "client_secret.json")
  tmpop = File.open(File.join(DIR_PATH, "secret", "username.txt"))
  USER_ID = tmpop.read.chomp.to_s
  tmpop.close
  # callback URL
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  attr_accessor :summary, :evt_start, :evt_end,
                :description, :recurrence, :is_all_day

  def initialize(summary, evt_start, evt_end,
                 description, recurrence, is_all_day)
    @summary = summary
    # is_all_day が true のときは Date を入れる。
    # is_all_day が false のときは Time を入れる。
    @evt_start = evt_start
    @evt_end = evt_end
    @description = description
    @recurrence = recurrence
    @is_all_day = is_all_day
  end

  def GCal.authorize()
    client_id = Google::Auth::ClientId.from_file(CLIENT_ID)
    token_store = Google::Auth::Stores::FileTokenStore.new(
      file: CREDENTIALS_PATH)
    scope = 'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, scope, token_store)
    credentials = authorizer.get_credentials(USER_ID)
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: OOB_URI)
      puts "Open the following URL in the browser and enter the " +
           "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: USER_ID, code: code, base_url: OOB_URI)
    end
    return credentials
  end

  def insert()
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = GCal.authorize
    
    h_tmp = {
      summary: self.summary
    }
    if !self.description.nil?
      h_tmp[:description] = self.description
    end
    if self.is_all_day.nil? || !self.is_all_day
      h_tmp[:start] = {
        date_time: self.evt_start.iso8601,
        time_zone: TIME_ZONE        
      }
      h_tmp[:end] = {
        date_time: self.evt_end.iso8601,
        time_zone: TIME_ZONE 
      }
    else
      h_tmp[:start] = {
        date: self.evt_start.to_s,
        time_zone: TIME_ZONE        
      }
      h_tmp[:end] = {
        date: self.evt_end.to_s,
        time_zone: TIME_ZONE 
      }
    end
    if !self.recurrence.nil?
      h_tmp[:recurrence] = ["RRULE:#{self.recurrence.to_ical}"]
    end
    
    event = Google::Apis::CalendarV3::Event.new(h_tmp)
    service.insert_event(GCAL_ID, event)
  end
end
