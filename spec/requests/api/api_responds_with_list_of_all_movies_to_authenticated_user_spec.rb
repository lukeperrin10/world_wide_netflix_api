RSpec.describe 'GET /api/movies', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  let(:user_tier_movies) do
    file_fixture('top_movie_search_api_response.json').read
  end
  let(:vistor_location) do
    file_fixture('visitor_location.json').read
  end
  describe 'Succesfully' do
    before do
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating')
        .to_return(status: 200, body: user_tier_movies)
      stub_request(:get, 'https://nominatim.openstreetmap.org/reverse?accept-language=en&addressdetails=1&format=json&lat=59.32021&lon=18.37827')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: vistor_location, headers: {})
      get '/api/movies', params: {
        lat: 59.32021,
        lon: 18.37827
      },
                         headers: auth_headers
    end

    it 'is expected to return status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a list of movies' do
      expect(response_json['body'].count).to eq 25
    end
  end

  describe 'user logs in but does not share their location ' do
    before do
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating')
        .to_return(status: 200, body: user_tier_movies)
      stub_request(:get, 'https://nominatim.openstreetmap.org/reverse?accept-language=en&addressdetails=1&format=json&lat=59.32021&lon=18.37827')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: '', headers: {})

      get '/api/movies', headers: auth_headers
    end

    it 'is expected to respond with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a list of movies' do
      expect(response_json['body'].count).to eq 30
    end
  end
end
