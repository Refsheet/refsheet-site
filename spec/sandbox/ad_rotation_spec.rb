require 'rails_helper'

describe 'Ad Rotation' do
  def getEmpty(slots)
    slots.select { |s| s[:ad_id].nil? }
  end

  def findSlot(slots, id)
    slots.select { |s| s[:id] == id }.first
  end

  def getIds(slots)
    slots.collect { |s| s[:id] }
  end

  it 'distributes within slots' do
    slots = []

    10.times do |i|
      slots.push id: i + 1, ad_id: nil
    end

    expect(getEmpty(slots).count).to eq 10

    ads = [
        { id: 'A', slots: 1 },
        { id: 'B', slots: 1 },
        { id: 'C', slots: 3 },
        { id: 'D', slots: 2 },
        { id: 'E', slots: 1 },
        { id: 'F', slots: 2 }
    ]

    ads.each do |ad|
      e = getIds getEmpty slots

      o = e.sort_by { |i|
        v = i % ad[:slots]
        v
      }

      ad[:slots].times do |i|
        s = findSlot slots, o[i]

        if s
          s[:ad_id] = ad[:id]
        else
          ad[:no_slot] = true
        end
      end
    end

    slots.each do |s|
      ad = ads.select{|a| a[:id] == s[:ad_id]}.first
      ad[:count] ||= 0
      ad[:count] += 1
    end

    ads.each do |ad|
      expect(ad[:count]).to eq ad[:slots]
    end

    expect(slots.collect{|s|s[:ad_id]}).to eq %w(A B C D E C F D C F)
  end
end
