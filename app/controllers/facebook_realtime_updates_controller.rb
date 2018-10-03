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
    updates = Koala::Facebook::RealtimeUpdates.new(:app_id => FACEBOOK_APP_ID, :secret => FACEBOOK_APP_SECRET)
    updates.subscribe('user', 'friends,movies', FACEBOOK_REALTIME_UPDATE_CALLBACK_URL, FACEBOOK_REALTIME_UPDATE_VERIFY_TOKEN)
    head :ok
  end
end
