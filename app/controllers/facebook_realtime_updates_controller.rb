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
    head :no_content
  end

  def subscribe
    # @access_token ||= Koala::Facebook::OAuth.new(FACEBOOK_API_KEY,FACEBOOK_API_SECRET).get_app_access_token
    updates = Koala::Facebook::RealtimeUpdates.new(app_id: FACEBOOK_APP_ID, secret: FACEBOOK_SECRET)
    updates.subscribe('user', 'name,uid,gender,email,location,hometown,friends,movies', FACEBOOK_REALTIME_UPDATE_CALLBACK_URL, FACEBOOK_REALTIME_UPDATE_VERIFY_TOKEN)
    head :no_content
    # redirect_to root_path
  end

  def realtime_request?(request)
    ((request.method == 'GET' && params['hub.mode'].present?) ||
       (request.method == 'POST' && request.headers['X-Hub-Signature'].present?))
 end

  def subscription
    return unless realtime_request?(request)
    case request.method
    when 'GET'
      # Koala::Facebook::RealtimeUpdates.meet_challenge(@params) do |token|
        # Your token verifying code
      # end
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
