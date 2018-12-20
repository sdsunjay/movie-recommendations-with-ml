class AddMoviesToUserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', :retry => 1, :dead => false # will retry 1 times and then disappear

  def perform(user_id)
    @user = User.find(user_id)
    @user.add_movies if @user
  end
end
