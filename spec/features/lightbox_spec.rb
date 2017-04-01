require 'rails_helper'

feature 'Lightbox', js: true do
  let(:image) { create :image }

  before { sign_in image.character.user }

  scenario 'user deletes image' do
    visit image_path image
    expect(page).to have_content image.character.name

    within '.image-actions' do
      page.find('#image-actions-menu').trigger(:click)
      expect(page).to have_content 'Delete...'
      page.find('#image-delete-link').trigger(:click)
    end

    expect(page).to have_content 'Are you sure?'
    page.find('#image-delete-confirm').trigger(:click)

    expect(page).to have_content 'deleted'
    expect(image.character.images.count).to eq 0
  end

  scenario 'user sets as cover' do
    visit image_path image
    expect(page).to have_content image.character.name

    page.find('#image-actions-menu').trigger(:click)
    expect(page).to have_content 'Set as Cover Image'

    click_link 'Set as Cover Image'
    expect(page).to have_content 'Cover image changed!'
    expect(image.character.reload.featured_image_id).to eq image.id
  end

  scenario 'user sets as profile' do
    visit image_path image
    expect(page).to have_content image.character.name

    page.find('#image-actions-menu').trigger(:click)
    expect(page).to have_content 'Set as Profile Image'

    click_link 'Set as Profile Image'
    expect(page).to have_content 'Profile image changed!'
    expect(image.character.reload.profile_image_id).to eq image.id
  end

  xcontext 'image flags' do
    scenario 'user set nsfw' do
      visit image_path image
      expect(page).to have_content image.character.name
      page.find('#image-actions-menu').trigger(:click)
      expect(page).to have_content 'Flag as NSFW'
      click_link 'Flag as NSFW'
      expect(page).to have_content 'flagged'
      expect(image.reload.nsfw?).to be_truthy
    end

    scenario 'user set public' do
      visit image_path image
      expect(page).to have_content image.character.name
      page.find('#image-actions-menu').trigger(:click)
      expect(page).to have_content 'Public'
      click_link 'Public'
      expect(page).to have_content 'hidden'
      expect(image.reload.hidden?).to be_truthy
    end
  end
end
