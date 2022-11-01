class PlacesController < ApplicationController
  def index
  end

  def show
    @places = Rails.cache.read(session[:city])
    if @places.nil?
      redirect_to places_path, notice: "Location not found in cache"
    else
      @place = @places.find { |place| place.id == params[:id] }
    end
  end

  def search
    city = params[:city]
    @places = BeermappingApi.places_in(city)
    @weather = WeatherApi.weather_in(city)
    # Store city into session to find places in cache
    session[:city] = city
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end
end
