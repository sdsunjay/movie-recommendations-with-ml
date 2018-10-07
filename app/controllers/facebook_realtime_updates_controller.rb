# match "facebook/subscription", :controller => :facebook, :action => :subscription, :as => 'facebook_subscription', :via => [:get,:post]
# @access_token ||= Koala::Facebook::OAuth.new(FACEBOOK_API_KEY,FACEBOOK_API_SECRET).get_app_access_token
# @realtime = Koala::Facebook::RealtimeUpdates.new(:app_id => FACEBOOK_API_KEY, :app_access_token => @access_token)
# @realtime.subscribe('user', 'first_name,uid,etc...', facebook_subscription_url,'SOME_TOKEN_HERE')
class FacebookRealtimeUpdatesController < ApplicationController
  def verify
    challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, FACEBOOK_REALTIME_UPDATE_VERIFY_TOKEN)
    respond_to do |format|
      format.text do
        render text: challenge
      end
    end
  end

  def update
    # TODO: Handle an incoming POST from Facebook
    head :ok
  end

  def subscribe
    updates = Koala::Facebook::RealtimeUpdates.new(app_id: FACEBOOK_APP_ID, secret: FACEBOOK_APP_SECRET)
    updates.subscribe('user', 'friends,movies', FACEBOOK_REALTIME_UPDATE_CALLBACK_URL, FACEBOOK_REALTIME_UPDATE_VERIFY_TOKEN)
    head :ok
  end

  def realtime_request?(request)
    ((request.method == 'GET' && params['hub.mode'].present?) ||
       (request.method == 'POST' && request.headers['X-Hub-Signature'].present?))
 end

  def subscription
    return unless realtime_request?(request)
    case request.method
    when 'GET'
      challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, 'SOME_TOKEN_HERE')
      if challenge
        render text: challenge
      else
        render plain: 'Failed to authorize facebook challenge request'
      end
    when 'POST'
      case params['object']
      when 'something'
        render plain: 'Thanks for the update'
      end
    end

  end
end
