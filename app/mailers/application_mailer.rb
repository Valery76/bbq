class ApplicationMailer < ActionMailer::Base
  default from: ENV['ACTION_MAILER_DEFAULT_SOURCE_EMAIL_ADDRESS']
  layout 'mailer'
end
