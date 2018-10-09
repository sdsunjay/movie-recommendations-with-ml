namespace :users do
    desc "Seed Admin User"
    task seed_users: :environment do
User.create!([
  {id: 1, name: "Sunjay Dhama", email: nil, location: nil, hometown: nil, gender: nil, password: "password", image: nil, link: nil, access_level: "super_admin", friends: nil, education: nil, provider: "facebook", uid: nil, token: nil, reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 3, current_sign_in_at: "2018-09-13 05:59:31", last_sign_in_at: "2018-09-11 23:17:53", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", created_at: "2018-09-11 08:21:11", updated_at: "2018-09-13 05:59:31"}
])
    puts "Created #{User.count} Users"
    end
end
