RSpec.describe 'POST /api/auth', type: :request do
  describe 'successfully' do
    before do
      post '/api/auth', params: {
        email: 'user@email.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    it 'is expeced to have status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['status']).to eq 'success'
    end
  end
end