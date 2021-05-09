RSpec.describe 'GET /api/movies', type: :request do
  let(:visitor_movies) do
    file_fixture('top_movie_search_api_response.json').read
  end
  let(:visitor_location) do
    file_fixture('visitor_location.json').read
  end

  describe 'successfully ' do
    before do
      stub_request(:get, 'https://nominatim.openstreetmap.org/reverse?accept-language=en&addressdetails=1&format=json&lat=59.32021&lon=18.37827')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: visitor_location)
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?orderby=rating&type=movie')
        .to_return(status: 200, body: visitor_movies)
      get '/api/movies', params: {
        lat: 59.32021,
        lon: 18.37827
      }
    end
    it 'is expected to return status 200' do
      expect(response).to have_http_status 200
    end

    it "is expected to return list of 10 movies outside visitor's country" do
      expect(response_json['body'].count).to eq 10
    end
  end
end
