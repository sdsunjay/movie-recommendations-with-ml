class AddFriendsToUserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', :retry => 5, :dead => false # will retry 5 times and then disappear

  def perform(user_id)
    @user = User.find(user_id)
    if @user
      @user.add_friends
    end
  end
end
