RSpec.describe 'POST /api/auth', type: :request do
  describe 'successfully' do
    before do
      post '/api/auth', params: {
        email: 'user@email.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    it 'is expeced to have status 201' do
      expect(subject).to have_http_status 201
    end

    it 'is expected to return a success message' do
      expect(response_json).to eq 'Congratulation, you\'ve successfully registered an account'
    end
  end
end