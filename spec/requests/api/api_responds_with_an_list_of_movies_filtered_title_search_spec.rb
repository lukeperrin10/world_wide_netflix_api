RSpec.describe 'GET /api/movies', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:title_search) do
    file_fixture('title_search.json').read
  end

  describe 'Successfully' do
    before do
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating&query=Alien')
        .to_return(status: 200, body: title_search, headers: {})

      get '/api/movies', params: {
        query: 'Alien',
      }, headers: auth_headers
    end

    it 'is expected to return a http status of 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a list of movies related to the search params' do
      expect(response_json['body']).to eq JSON.parse(title_search)
    end
  end

  describe 'Unsuccessfully' do
    before do
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating&query=Alien')
        .to_return(status: 200, body: title_search, headers: {})

      get '/api/movies', params: {
        query: 'Alien',
      }
    end

    it 'is expected to return a http status of 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to return a list of movies related to the search params' do
      expect(response_json['error']).to eq 'You need to have an account to use this feature'
    end
  end
end