require 'rails_helper'

feature 'Lightbox', js: true do
  let(:image) { create :image }

  before { sign_in image.character.user }

  scenario 'user deletes image' do
    visit image_path image
    expect(page).to have_content image.character.name

    click_link 'more_vert'
    expect(page).to have_content 'Delete'

    click_link 'Delete'
    expect(page).to have_content 'Are you sure?'

    click_link 'DELETE IMAGE'
    expect(page).to have_content 'deleted'
    expect(image.character.images.count).to eq 0
  end

  scenario 'user sets as cover' do
    visit image_path image
    expect(page).to have_content image.character.name

    click_link 'more_vert'
    expect(page).to have_content 'Set as Cover Image'

    click_link 'Set as Cover Image'
    expect(page).to have_content 'Cover image changed!'
    expect(image.character.reload.featured_image_id).to eq image.id
  end

  scenario 'user sets as profile' do
    visit image_path image
    expect(page).to have_content image.character.name

    click_link 'more_vert'
    expect(page).to have_content 'Set as Profile Image'

    click_link 'Set as Profile Image'
    expect(page).to have_content 'Profile image changed!'
    expect(image.character.reload.profile_image_id).to eq image.id
  end
end
