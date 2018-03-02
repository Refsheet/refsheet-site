class ModeratorMailer < ApplicationMailer
  def new_report(report, moderator)
    @report = report
    @user = moderator

    mail to: @user.email_to,
         subject: '[Refsheet.net] New Moderation Report'
  end

  def item_removed(report)
    @report = report
    @user = report.user
    @preheader = 'Some of your content has been removed by a moderator action.'

    mail to: @user.email_to,
         subject: '[Refsheet.net] Moderator Action: Content Removed'
  end

  def item_reflagged(report)
    @report = report
    @user = report.user
    @preheader = 'Some of your content has been reflagged by a moderator.'

    mail to: @user.email_to,
         subject: '[Refsheet.net] Moderator Action: Content Reflagged'
  end

  def item_moderated(report)
    @report = report
    @user = report.user
    @preheader = 'Some of your content has been modified by a moderator action.'

    mail to: @user.email_to,
         subject: '[Refsheet.net] Moderator Action: Content Moderated'
  end
end
