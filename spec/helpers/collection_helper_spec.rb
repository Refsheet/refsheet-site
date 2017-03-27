require 'rails_helper'

describe CollectionHelper, type: :helper do
  describe '#taper_group' do
    it 'properly tapers' do
      items = [
          2.months.ago,
          1.second.ago,
          1.week.ago,
          1.day.ago,
          3.days.ago,
          1.month.ago,
          1.second.from_now
      ].collect do |duration|
        OpenStruct.new(to_s: time_ago_in_words(duration), created_at: duration)
      end

      taper = taper_group items

      expect(taper["Today"]).to have(2).items
      expect(taper["This Week"]).to have(2).items
      expect(taper["This Month"]).to have(1).items
      expect(taper["Older"]).to have(2).items

      expect(taper.keys).to eq ["Today", "This Week", "This Month", "Older"]
    end
  end
end
