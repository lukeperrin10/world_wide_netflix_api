RSpec.describe 'POST /api/subscriptions', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  describe 'successful' do
    before do
      post '/api/subscriptions',
           params: {
             stripeToken: '0123456789'
           },
           headers: auth_headers
    end

    it 'is expected to return 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a correct response' do
      expected_response = { "paid": true, "message": "Thank you for subscribing!" }
      expect(response_json).to eq expected_response
    end

    it 'is expected to make user a subscriber' do
      expect(user.reload.subscriber?).to eq true
    end
  end
end
