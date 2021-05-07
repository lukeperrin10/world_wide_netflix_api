RSpec.describe 'GET /api/movies/' do
  # let (:geocoder) {create(:geocoder)}
    before do
      get '/api/movies?lat=55.7842&long=12.4518'
      # Geocoder.configure(lookup: :test)
      # Geocoder::Lookup::Test.set_default_stub(
      #   [
      #     {
      #       'latitude'     => 55.7842,
      #       'longitude'    => 12.4518,
      #       'country' => 'Denmark'
      #     },
      #   ]
      # )
    end
    it 'is expected to return status 200' do
      binding.pry
      expect(response_json).to have_http_status 200 
    end
end