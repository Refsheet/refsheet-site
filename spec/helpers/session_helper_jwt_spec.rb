require 'rails_helper'

describe SessionHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#authenticate_from_jwt' do
    context 'with valid JWT token' do
      let(:token) do
        JWT.encode({ sub: user.id, exp: 1.day.from_now.to_i }, 'test_secret', 'HS256')
      end

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('JWT_SECRET').and_return('test_secret')
        allow(helper).to receive(:request).and_return(
          double(headers: { 'Authorization' => "Bearer #{token}" })
        )
      end

      it 'returns the user' do
        expect(helper.send(:authenticate_from_jwt)).to eq(user)
      end
    end

    context 'with expired JWT token' do
      let(:token) do
        JWT.encode({ sub: user.id, exp: 1.day.ago.to_i }, 'test_secret', 'HS256')
      end

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('JWT_SECRET').and_return('test_secret')
        allow(helper).to receive(:request).and_return(
          double(headers: { 'Authorization' => "Bearer #{token}" })
        )
      end

      it 'returns nil' do
        expect(helper.send(:authenticate_from_jwt)).to be_nil
      end
    end

    context 'with invalid JWT secret' do
      let(:token) do
        JWT.encode({ sub: user.id, exp: 1.day.from_now.to_i }, 'wrong_secret', 'HS256')
      end

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('JWT_SECRET').and_return('test_secret')
        allow(helper).to receive(:request).and_return(
          double(headers: { 'Authorization' => "Bearer #{token}" })
        )
      end

      it 'returns nil' do
        expect(helper.send(:authenticate_from_jwt)).to be_nil
      end
    end

    context 'with no Authorization header' do
      before do
        allow(helper).to receive(:request).and_return(
          double(headers: {})
        )
      end

      it 'returns nil' do
        expect(helper.send(:authenticate_from_jwt)).to be_nil
      end
    end

    context 'with missing JWT_SECRET' do
      let(:token) do
        JWT.encode({ sub: user.id }, 'test_secret', 'HS256')
      end

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('JWT_SECRET').and_return(nil)
        allow(helper).to receive(:request).and_return(
          double(headers: { 'Authorization' => "Bearer #{token}" })
        )
      end

      it 'returns nil' do
        expect(helper.send(:authenticate_from_jwt)).to be_nil
      end
    end

    context 'with nonexistent user ID' do
      let(:token) do
        JWT.encode({ sub: 999999, exp: 1.day.from_now.to_i }, 'test_secret', 'HS256')
      end

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('JWT_SECRET').and_return('test_secret')
        allow(helper).to receive(:request).and_return(
          double(headers: { 'Authorization' => "Bearer #{token}" })
        )
      end

      it 'returns nil' do
        expect(helper.send(:authenticate_from_jwt)).to be_nil
      end
    end
  end
end
