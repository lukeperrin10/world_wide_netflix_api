class Api::MoviesController < ApplicationController
  

  def index    
    netflix = Rails.application.credentials.unogsng_key
   
    begin
      if params.has_key?(:query)
        if current_user
          response = RestClient.get("https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating&query=#{params['query']}",
            headers = { 'x-rapidapi-key': netflix })
          user_tier_render(JSON.parse(response))
        else
          render json: { error: 'You need to have an account to use this feature' }, status: 401
        end
      else
        if params.has_key?(:lat) && params.has_key?(:lon)
          response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating',
            headers = { 'x-rapidapi-key': netflix })
          higher_rated_movies = netflix_sort(response)
          country = get_country(params)        
          movie_results = higher_rated_movies.select { |movie| !movie['clist'].include?(country) }
          if current_user      
            user_tier_render(movie_results)
          else
            visitor_tier_render(movie_results)
          end
        else 
          if current_user
            user_tier_render(higher_rated_movies)
          else
            visitor_tier_render(higher_rated_movies)
          end
        end        
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
      render json: { body: movies_to_render }, status: 200    
  end

  def visitor_tier_render(movies_to_render)
    render json: { body: movies_to_render[0..9] }, status: 200
  end
end
