require 'rails_helper'

feature 'Shortcodes' do
  let(:character) { create :character, shortcode: 'foo' }

  xit 'handles route constraint' do
    # TODO find a better way to test this.
  end
end
