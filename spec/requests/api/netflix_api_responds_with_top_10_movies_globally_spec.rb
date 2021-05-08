RSpec.describe 'GET /api/movies', type: :request do
  let(:top_100_response) do
    file_fixture('top_movie_search_api_response.json').read
  end

  let(:filtered_top_10) do
    file_fixture('top_10_avgrating_filter.json').read
  end

  let(:open_cage_response) do
    file_fixture('visitor_location.json')
  end

  describe 'successfully receives top 10 movies globally' do
    before do
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating')
        .to_return(status: 200, body: top_100_response)
      get '/api/movies'
    end

    it 'is expected to respond 200' do
      expect(response).to have_http_status 200
    end

    it 'filter top 10 movies globally' do
      expect(response_json['body'].count).to eq 10
    end

    it 'is expected to return filter low Netflix rating movies' do
      expect(response_json['body']).to eq JSON.parse(filtered_top_10)['results']
    end
  end

  describe 'Unsuccesfully' do
    before do
      stub_request(:get, 'https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating')
        .to_return(status: 500, body: nil)
      get '/api/movies'
    end

    it 'is expected to respond 500' do
      expect(response).to have_http_status 500
    end

    it 'is expected to have a message' do
      expect(response_json['error']).to eq "500 Internal Server Error |  0 bytes\n"
    end
  end
end
