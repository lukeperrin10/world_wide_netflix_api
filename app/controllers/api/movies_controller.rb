class Api::MoviesController < ApplicationController
  def index
    netflix = Rails.application.credentials.unogsng_key

    begin
      if params.has_key?(:lat) && params.has_key?(:lon)
        country_results = Geocoder.search([params[:lat], params[:lon]])
        country = country_results.first.country

        response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating',
                                  headers = { 'x-rapidapi-key': netflix })
        movie_array = JSON.parse(response.body)['results']

        movie_results = movie_array.select { |movie| !movie['clist'].include?(country) }
        render json: { body: movie_results[0..9]}, status: 200

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
