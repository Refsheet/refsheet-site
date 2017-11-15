class MoveAdvertisementImages < ActiveRecord::Migration[5.0]
  class ::TempAdUp < Advertisement::Campaign
    self.table_name = 'advertisement_campaigns'

    has_attached_file :image,
                      path: '/our_friends/:guid/:style.:extension',
                      hash_secret: 'totally-not-an-advertisement-i-swear',
                      styles: {
                      small: ['100x75>', :png],
                      medium: ['200x150>', :png],
                      large: ['400x300>', :png]
    }
  end

  class ::TempAdDown < Advertisement::Campaign
    self.table_name = 'advertisement_campaigns'

    has_attached_file :image,
                      path: '/advertisement/campaigns/:attachment/:id_partition/:style/:filename',
                      styles: {
                          small: ['100x75>', :png],
                          medium: ['200x150>', :png],
                          large: ['400x300>', :png]
                      }
  end

  def up
    TempAdUp.find_each do |ad|
      puts 'Updating Ad: ' + ad.title
      ad.update! image: TempAdDown.find_by(id: ad.id)&.image

      [:original, :small, :medium, :large].each do |style|
        puts '  -> ' + ad.image.url(style)
      end
    end
  end

  def down
    TempAdDown.find_each do |ad|
      puts 'Updating Ad: ' + ad.title
      ad.update! image: TempAdUp.find_by(id: ad.id)&.image
      puts '  -> ' + ad.image.url(:original)
    end
  end
end
