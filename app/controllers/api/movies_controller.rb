class Api::MoviesController < ApplicationController
  before_action :authenticate_user, only: :user_tier_render

  def index    
    netflix = Rails.application.credentials.unogsng_key

    begin
      response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating',
                                headers = { 'x-rapidapi-key': netflix })
      higher_rated_movies = netflix_sort(response)
      if params.has_key?(:lat) && params.has_key?(:lon)
        country = get_country(params)
        movie_results = higher_rated_movies.select { |movie| !movie['clist'].include?(country) }        
        user_tier_render(movie_results)
        render json: { body: movie_results[0..9] }, status: 200
      elsif user_tier_render(higher_rated_movies)
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

  def user_tier_render(movies_to_render)
      binding.pry
      render json: { body: movies_to_render }, status: 200    
  end


end

# render json: { body: movies_to_render[0..9] }, status: 200
