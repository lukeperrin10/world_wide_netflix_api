class Api::MoviesController < ApplicationController
  def index
    netflix = Rails.application.credentials.unogsng_key

    begin
      response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating',
                                headers = { 'x-rapidapi-key': netflix })
      results = JSON.parse(response)['results'].select { |film| film['avgrating'] > 4 }
      netflix_sorted = results.sort_by { |film| film['avgrating'] }.reverse
      render json: { body: netflix_sorted[0..9] }, status: 200
    rescue StandardError => e
      render json: { error: e.response.description }, status: e.response.code
    end
  end
end
