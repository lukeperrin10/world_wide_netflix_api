RSpec.describe 'POST /api/subscriptions', type: :request do
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }

  describe 'successful' do
    let(:user) { create(:user) }
    let(:auth_headers) { user.create_new_auth_token }
    let(:stripe_token) { StripeMock.create_test_helper.generate_card_token }
      before do
        post '/api/subscriptions',
            params: {
              stripeToken: stripe_token
            },
            headers: auth_headers
      end

      it 'is expected to return 200 status' do
        expect(response).to have_http_status 200
      end

      it 'is expected to return a correct response' do
        expected_response = { message: 'Thank you for subscribing!', paid: true }
        expect(response_json).to eq expected_response.as_json
      end

      it 'is expected to make user a subscriber' do
        expect(user.reload.subscriber?).to eq true
      end
  end
end
