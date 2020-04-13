require 'rails_helper'

feature 'Characters / Gallery', js: true do
  let(:character) { create :character, :with_images, name: "Gallery Test Char", version: 1 }
  let(:user) { character.user }

  let(:sfw_img) { character.images.to_a.find { |i| !i.nsfw && !i.hidden } }
  let(:nsfw_img) { character.images.to_a.find { |i| i.nsfw } }
  let(:hidden_img) { character.images.to_a.find { |i| i.hidden } }

  before(:each) do
    sign_in user
    visit "/#{character.user.username}/#{character.slug}"
    expect(page).to have_content character.name
  end

  context "signed out" do
    let(:user) { nil }

    it "hides hidden images" do
      within("#gallery") do
        expect_data(gallery_image_id: sfw_img.guid)
        expect_no_data(gallery_image_id: hidden_img.guid)
      end
    end
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

  it "has images" do
    within "#gallery" do
      expect_data(gallery_image_id: sfw_img.guid)
      expect_data(gallery_image_id: nsfw_img.guid)
      expect_data(gallery_image_id: hidden_img.guid)
    end
  end

  it "shows image title on hover" do
    within "#gallery" do
      expect(page).to have_no_content(sfw_img.title[0,10])
      find(data_attr(gallery_image_id: sfw_img.guid)).hover
      expect(page).to have_content(sfw_img.title[0,10])
    end
  end
end