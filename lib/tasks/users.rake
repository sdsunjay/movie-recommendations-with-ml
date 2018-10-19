namespace :users do
    desc "Seed Admin User"
    task seed_users: :environment do
User.create!([{id: 1, name: "Sunjay Dhama", email: "dhamaharpal@gmail.com", location: "Oakland, California", hometown: "Wakefield, MA", gender: "male", password: "password", image: "http://graph.facebook.com/v3.1/10205306719984646/picture?type=large", link: nil, access_level: "super_admin", friends: nil, education: "", provider: "facebook", uid: "10205306719984646", token: "hidden", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 5, current_sign_in_at: "2018-10-17 21:37:06", last_sign_in_at: "2018-10-12 00:53:54", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", created_at: "2018-09-11 08:21:11", updated_at: "2018-09-13 05:59:31", token_expires_at: "2018-12-09 19:24:39"}])
    puts "Created #{User.count} Users"
    end
end
