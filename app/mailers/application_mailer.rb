class ApplicationMailer < ActionMailer::Base
  default from: 'support@movierecommendationswithml.com'
  default to: 'Movie Recommendations With ML <support@movierecommendationswithml.com>'
  layout 'mailer'
end
