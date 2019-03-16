require 'rails_helper'

describe ImageProxyController, type: :controller do
  let(:url) { 'http://mypa.ws/paws.jpg' }

  describe '::generate' do
    subject { ImageProxyController.generate(url) }

    it { is_expected.to match %r{\Ahttps://ref\.st/e/[-A-Za-z0-9+/=]+\?key=[a-f0-9]+\z} }
  end

  describe '::generate_parts' do
    let(:parts) { ImageProxyController.generate_parts(url) }
    subject { parts }

    its(:key) { is_expected.to match /\A[a-f0-9]+\z/ }
    its(:token) { is_expected.to match %r{\A[-A-Za-z0-9+/=]+\z} }

    describe '#get' do
      let(:token) { parts.token }
      let(:key) { parts.key }

      before { get :get, params: { url: token, key: key } }

      subject { response }

      its(:status) { is_expected.to eq 200 }
      its(:content_type) { is_expected.to eq 'image/jpeg' }

      context 'with invalid key' do
        let(:key) { 'foo' }

        its(:status) { is_expected.to eq 418 }
      end
    end
  end

  it 'properly renders markdown strings' do
    user = create :user, username: 'FancyUser', name: 'Fancy Pants User'

    str = <<-MARKDOWN.squish
      @FancyUser: ![](http://mypa.ws/paws.jpg)
    MARKDOWN

    html = str.to_md.to_html
    
    puts html
    expect(html).to match %r{src="https://ref\.st/e/.*\?key=[a-f0-9]+"}
    expect(html).to match %r{data-canonical-url="http://mypa\.ws/paws\.jpg"}
    # Does not interfere with tag processing
    expect(html).to match %r{href=['"]/FancyUser['"]}
    expect(html).to match %r{>\s*Fancy Pants User\s*</a>}
    expect(html).to match %r{alt=['"]Fancy Pants User['"]}
  end
end
