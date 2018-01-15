class ApplicationMailer < ActionMailer::Base
  default from: 'Refsheet.net <mau@refsheet.net>'
  add_template_helper(MailerHelper)

  layout 'mailer'
end
