RSpec.describe 'GET /api/movies/' do
  let(:vistor_location) do
    file_fixture('visitor_location.json').read
  end
  let(:top_100_response) do
    file_fixture('top_movie_search_api_response.json').read
  end

  before do
    stub_request(:get, 'https://nominatim.openstreetmap.org/reverse?accept-language=en&addressdetails=1&format=json&lat=59.32021&lon=18.37827')
      .to_return(status: 200, body: vistor_location, headers: {})
    stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating')
      .to_return(status: 200, body: top_100_response)

    get '/api/movies/?lat=59.32021&lon=18.37827'
  end
  it 'is expected to return status 200' do
    expect(response).to have_http_status 200
  end
  it 'is expected to return list of 10 movies' do
    expect(response_json['body'].count).to eq 10
  end
  it 'is expected to show a list of 10 movies from outside the visitors country' do
    expect(response_json['body']).not_to include('Sweden')
  end
end
