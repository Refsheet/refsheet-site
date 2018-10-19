require 'rails_helper'

describe CollectionHelper, type: :helper do
  describe '#taper_group' do
    it 'properly tapers' do
      Timecop.travel(Time.new(2017, 3, 16, 14, 0, 0)) do
        items = [
            2.months.ago, # Older
            1.second.ago, # Today
            1.week.ago,   # This Month
            1.day.ago,    # This Week
            3.days.ago,   # This Week
            1.month.ago,  # Older
            1.second.from_now # Today
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
end
