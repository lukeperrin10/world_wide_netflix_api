class Api::MoviesController < ApplicationController
  def index
    netflix = Rails.application.credentials.unogsng_key

    begin
      if params.has_key?(:lat) && params.has_key?(:long)
        results = Geocoder.search([params[:lat], params[:long]])
        country = results.first.country
        binding.pry

      elsif response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating',
                                      headers = { 'x-rapidapi-key': netflix })

        results = JSON.parse(response)['results'].select { |film| film['avgrating'] > 4 }
        netflix_sorted = results.sort_by { |film| film['avgrating'] }.reverse
        render json: { body: netflix_sorted[0..9] }, status: 200

      end
    rescue StandardError => e
      render json: { error: e.response.description }, status: e.response.code
    end
  end
end
