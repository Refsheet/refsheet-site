require 'rails_helper'

feature 'Characters / Swatches', js: true do
  let(:character) { create :character,
                           :with_swatches,
                           name: "Swatch Test Char",
                           version: 1 }

  let(:user) { character.user }

  def create_swatch(name: 'Swatch!', color: '#123456', notes: nil, expect: false)
    within "#swatch-menu" do
      click_testid("swatch-panel-open")
      click_link("add")

      fill_in("name", with: name)
      fill_in("value", with: color)
      fill_in("notes", with: notes) if notes
      click_link("save")

      if expect
        expect(page).to have_content(name)

        within '.attribute-form' do
          expect(page).to have_no_content(name)
        end
      end
    end
  end

  before(:each) do
    sign_in user
    visit "/#{character.user.username}/#{character.slug}"
    expect(page).to have_content character.name
  end

  it 'has swatch panel' do
    expect_testid("swatch-panel-open")
  end

  it 'expands swatch panel' do
    within "#swatch-menu" do
      expect(page).to have_no_content(character.swatches.first.name)
      click_testid("swatch-panel-open")
      expect(page).to have_content(character.swatches.first.name)
    end
  end

  it 'creates swatch' do
    within "#swatch-menu" do
      swatch_name = "test-swatch-name"
      swatch_color = "#212121"
      expect(page).to have_no_content(swatch_name)
      click_testid("swatch-panel-open")
      expect(page).to have_no_content(swatch_name)
      click_link("add")
      fill_in("name", with: swatch_name)
      fill_in("value", with: swatch_color)
      click_link("save")
      expect(page).to have_no_content(swatch_name)
    end
  end

  describe 'swatch creation' do
    it 'creates swatch' do
      create_swatch(name: "test-swatch-name", color: "#212121", expect: true)
    end

    it 'creates rgb' do
      skip "Non-hex codes not yet supported."
      create_swatch(color: "rgb(0,0,0)", expect: true)
    end

    it 'creates rgb 2' do
      skip "Non-hex codes not yet supported."
      create_swatch(color: "rgb(255, 255 ,255)", expect: true)
    end

    it 'creates rgba' do
      skip "Non-hex codes not yet supported."
      create_swatch(color: "rgba(0,0,0,0.3)", expect: true)
    end

    it 'creates hsl' do
      skip "Non-hex codes not yet supported."
      create_swatch(color: "hsl(127,0,0)", expect: true)
    end

    it 'rejects invalid color' do
      create_swatch(color: "nacho cheese")
      within '#swatch-menu' do
        expect(page).to have_content "can only use hexadecimal color codes"
      end
    end
  end

  it 'deletes swatch' do
    swatch = character.swatches.first
    click_testid("swatch-panel-open")
    within '#swatch-menu' do
      within "[data-attribute-id=\"#{swatch.guid}\"]" do
        expect(page).to have_content swatch.name
        click_link("delete")
      end

      expect(page).to have_no_selector "[data-attribute-id=\"#{swatch.guid}\"]"
    end

    expect { swatch.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'edits swatch' do
    swatch = character.swatches.first
    click_testid("swatch-panel-open")
    within '#swatch-menu' do
      within "[data-attribute-id=\"#{swatch.guid}\"]" do
        expect(page).to have_content swatch.name
        click_link("edit")
        fill_in("name", with: 'Alphinaud')
        click_link("save")
        expect(page).to have_no_content swatch.name
        expect(page).to have_content "Alphinaud"
      end
    end

    expect(swatch.reload.name).to eq "Alphinaud"
  end

  context "signed out" do
    let(:user) { nil }
  end
end