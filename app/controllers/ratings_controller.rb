class RatingsController < ApplicationController
  # GET /ratings or /ratings.json
  def index
    @ratings = Rating.all
    @recent = Rating.recent
    top_n = 3
    @top_breweries = Brewery.top top_n
    @top_beers     = Beer.top top_n
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
