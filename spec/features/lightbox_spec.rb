require 'rails_helper'

feature 'Lightbox', js: true do
  let(:image) { create :image }

  before { sign_in image.character.user }

  scenario 'user deletes image' do
    visit image_path image
    expect(page).to have_content image.character.name

    find('.image-content').hover
    expect(page).to have_content 'Delete'
    click_link 'Delete'

    expect(page).to have_content 'Are you sure?'
    click_link 'DELETE IMAGE'

    expect(page).to have_content 'deleted'
    expect(image.character.images.count).to eq 0
  end
end
