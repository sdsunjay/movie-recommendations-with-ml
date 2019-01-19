if Rails.env.development?
  ENV["BLAZER_DATABASE_URL"] = Rails.application.credentials.development[:blazer_database_url]
end
if Rails.env.production?
  ENV["BLAZER_DATABASE_URL"] = Rails.application.credentials.production[:blazer_database_url]
end
