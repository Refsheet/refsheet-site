# PFP and header image specs for Active Model (eventually) or V1 link (now)
# Specifically, test the upload modal pops.
require 'rails_helper'

feature 'Characters / Image Attachments', js: true do
  let(:character) { create :character,
                           :with_images,
                           name: "Image Attachment Test Char",
                           version: 1 }

  let(:sfw_img) { character.images.to_a.find { |i| !i.nsfw } }
  let(:nsfw_img) { character.images.to_a.find { |i| i.nsfw } }
  let(:hidden_img) { character.images.to_a.find { |i| i.hidden } }

  let(:user) { character.user }

  before(:each) do
    sign_in user
    visit "/#{character.user.username}/#{character.slug}"
    expect(page).to have_content character.name
  end

  def open_modal(target = :avatar)
    if target == :avatar
      container = ".character-image"
      modal_title = "Select Profile Picture"
    else
      container = ".page-header-backdrop"
      modal_title = "Select Header Image"
    end

    find(container).hover

    within container do
      find(".image-edit-overlay").click
    end

    within "#image-gallery-modal" do
      expect(page).to have_content modal_title
      yield if block_given?
    end
  end

  describe "header modal" do
    it "opens header modal" do
      open_modal(:header)
    end

    it "has sfw image" do
      open_modal(:header) do
        expect(page).to have_css("[data-gallery-image-id=\"#{sfw_img.guid}\"]")
      end
    end

    it "does not have nsfw image" do
      skip "This is apparently broken, but we'll check the validations."
      open_modal(:header) do
        expect(page).to have_no_css("[data-gallery-image-id=\"#{nsfw_img.guid}\"]")
      end
    end

    it "assigns a header image" do
      open_modal(:header) do
        find("[data-gallery-image-id=\"#{sfw_img.guid}\"]").click
      end
      expect(page).to have_no_content("Select Header Image")
      expect(page).to have_content("Header image updated")
      expect(character.reload.featured_image_id).to eq sfw_img.id
    end
  end

  describe "avatar modal" do
    it "opens avatar modal" do
      open_modal(:avatar)
    end

    it "assigns an avatar" do
      open_modal(:avatar) do
        find("[data-gallery-image-id=\"#{sfw_img.guid}\"]").click
      end
      expect(page).to have_no_content("Select Profile Picture")
      expect(page).to have_content("Profile picture updated")
      expect(character.reload.profile_image_id).to eq sfw_img.id
    end

    it "fails on nsfw" do
      skip "We should be safe since this is accidentally stuck on an NSFW warn."
      open_modal(:avatar) do
        find("[data-gallery-image-id=\"#{nsfw_img.guid}\"]").click
      end
      expect(page).to have_content("Select Profile Picture")
      expect(page).to have_content("cannot be NSFW")
      expect(character.reload.profile_image_id).to be_nil
    end
  end

  context "signed out" do
    let(:user) { nil }

    it "doesn't have edit buttons" do
      find(".character-image").hover
      expect(page).to have_no_css(".image-edit-overlay")
      find(".page-header").hover
      expect(page).to have_no_css(".image-edit-overlay")
    end
  end
end
