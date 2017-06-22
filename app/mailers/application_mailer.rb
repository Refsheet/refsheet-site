class ApplicationMailer < ActionMailer::Base
  default from: 'Refsheet.net <no-reply@refsheet.net>'
  add_template_helper(MailerHelper)

  layout 'mailer'
end
