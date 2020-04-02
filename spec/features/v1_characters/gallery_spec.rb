require 'rails_helper'

feature 'Characters / Gallery', js: true do
  let(:character) { create :character, name: "Gallery Test Char", version: 1 }
  let(:user) { character.user }

  before(:each) do
    sign_in user
    visit "/#{character.user.username}/#{character.slug}"
    expect(page).to have_content character.name
  end

  context "signed out" do
    let(:user) { nil }
  end

  it "triggers modal from FAB" do
    find('.fixed-action-btn').click
    find('.fixed-action-btn a#image-upload').click
    expect(page).to have_content "Upload To: Gallery Test Char"
  end

  it "triggers modal from Gallery" do
    within "#gallery" do
      find('#galleryUpload').click
    end

    expect(page).to have_content "Upload To: Gallery Test Char"
  end

end