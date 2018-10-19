# == Schema Information
#
# Table name: moderation_reports
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  sender_user_id   :integer
#  moderatable_id   :integer
#  moderatable_type :string
#  violation_type   :string
#  comment          :text
#  dmca_source_url  :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_moderation_reports_on_moderatable_id    (moderatable_id)
#  index_moderation_reports_on_moderatable_type  (moderatable_type)
#  index_moderation_reports_on_sender_user_id    (sender_user_id)
#  index_moderation_reports_on_status            (status)
#  index_moderation_reports_on_user_id           (user_id)
#  index_moderation_reports_on_violation_type    (violation_type)
#

require 'rails_helper'

describe ModerationReport, type: :model do
  let(:violation_type) { 'dmca' }
  let(:image) { create :image }
  let(:moderation_report) { create :moderation_report, violation_type: violation_type, moderatable: image }

  it 'sends moderator mail' do
    expect_live_mailer ModeratorMailer, :new_report
    create :admin
    create :moderation_report
  end

  context 'dmca' do
    let(:violation_type) { 'dmca' }

    describe '#remove!' do
      it 'mails user' do
        expect_live_mailer ModeratorMailer, :item_removed
        moderation_report.remove!
      end

      it 'deletes image' do
        moderation_report.remove!
        expect(image.reload).to be_deleted
      end
    end

    describe '#auto_resolve!' do
      it 'mails user' do
        expect_live_mailer ModeratorMailer, :item_removed
        moderation_report.auto_resolve!
      end

      it 'deletes image' do
        moderation_report.auto_resolve!
        expect(image.reload).to be_deleted
        expect(moderation_report).to be_removed
      end
    end
  end

  context 'offensive' do
    let(:violation_type) { 'offensive' }

    describe '#auto_resolve!' do
      it 'mails user' do
        expect_live_mailer ModeratorMailer, :item_removed
        moderation_report.auto_resolve!
      end

      it 'deletes image' do
        moderation_report.auto_resolve!
        expect(image.reload).to be_deleted
        expect(moderation_report).to be_removed
      end
    end
  end

  context 'improper_flag' do
    let(:violation_type) { 'improper_flag' }

    describe '#reflag!' do
      it 'mails user' do
        expect_live_mailer ModeratorMailer, :item_reflagged
        moderation_report.reflag!
      end

      it 'deletes image' do
        moderation_report.reflag!
        expect(image.reload).to be_nsfw
      end
    end

    describe '#auto_resolve!' do
      it 'mails user' do
        expect_live_mailer ModeratorMailer, :item_reflagged
        moderation_report.auto_resolve!
      end

      it 'deletes image' do
        moderation_report.auto_resolve!
        expect(image.reload).to be_nsfw
        expect(moderation_report).to be_reflagged
      end
    end
  end
end
