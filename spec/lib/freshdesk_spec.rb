require 'rails_helper'

describe Freshdesk do
  it "configure", :aggregate_errors do
    Freshdesk.configure do |config|
      config.domain = "foo"
      config.api_key = "abc123"
    end

    expect(Freshdesk.instance.endpoint_url).to eq "https://foo.freshdesk.com/api/v2"
    expect(Freshdesk.instance.api_key).to eq "abc123"
  end

  context "when configured" do
    before do
      Freshdesk.configure do |config|
        config.domain = "foo"
        config.api_key = "abc123"
      end
    end

    it "gets a client" do
      expect(Freshdesk.instance.client).to be_a Her::API
    end

    describe Freshdesk::Base, :webmock do
      it "gets foos" do
        stub = stub_request(:get, "https://foo.freshdesk.com/api/v2/bases/992")

        Freshdesk::Base.find(992).to_s
        expect(stub).to have_been_requested
      end

      it "creates foos" do
        stub = stub_request(:post, "https://foo.freshdesk.com/api/v2/bases").
                # with(body: hash_including(asdf: 'bones')). # https://github.com/bblimke/webmock/issues/348
                to_return(status: 200, body: '{"base":{"asdf":"bones"}}')

        foo = Freshdesk::Base.new
        foo.asdf = 'bones'
        foo.body = nil
        foo.save

        expect(stub).to have_been_requested
      end
    end
  end
end
