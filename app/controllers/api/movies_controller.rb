class Api::MoviesController < ApplicationController
  def index
    netflix = Rails.application.credentials.unogsng_key

    begin
      response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating',
                                headers = { 'x-rapidapi-key': netflix })
      higher_rated_movies = netflix_sort(response)
      if params.has_key?(:lat) && params.has_key?(:lon)
        country = get_country(params)
        movie_results = higher_rated_movies.select { |movie| !movie['clist'].include?(country) }
        render json: { body: movie_results[0..9] }, status: 200
      elsif render json: { body: higher_rated_movies[0..9] }, status: 200
      end
    rescue StandardError => e
      render json: { error: e.response.description }, status: e.response.code
    end
  end

  private

  def get_country(params)
    country_results = Geocoder.search([params[:lat], params[:lon]])
    country_results.first.country
  end

  def netflix_sort(list_of_movies)
    results = JSON.parse(list_of_movies)['results'].select { |film| film['avgrating'] > 4 }
    results.sort_by { |film| film['avgrating'] }.reverse
  end
end
