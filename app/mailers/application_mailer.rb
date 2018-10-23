class ApplicationMailer < ActionMailer::Base
  default from: 'Refsheet.net <mau@refsheet.net>'
  add_template_helper(MailerHelper)

  layout 'mailer'

  def allowed?(user, key: :all)
    user&.email_allowed? key
  end
end
