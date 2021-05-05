class Api::MoviesController < ApplicationController
  require 'rest-client'

  def index
    netflix = Rails.application.credentials.unogsng_key
    response = RestClient.get('https://unogsng.p.rapidapi.com/search?type=movie&orderby=rating', headers = {'x-rapidapi-key': netflix})
    result = JSON.parse(response)["results"][0..9]
    render json: {body: result}, status: 200
  end
end
