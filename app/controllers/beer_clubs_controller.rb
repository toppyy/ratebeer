class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_is_admin, only: [:destroy]

  # GET /beer_clubs or /beer_clubs.json
  def index
    @beer_clubs = BeerClub.all

    order = params[:order] || 'name'

    @beer_clubs = case order
                  when "name" then @beer_clubs.sort_by(&:name)
                  when "year" then @beer_clubs.sort_by(&:founded)
                  when "city" then @beer_clubs.sort_by(&:city)
                  end
  end

  # GET /beer_clubs/1 or /beer_clubs/1.json
  def show
    if current_user.nil?
      @current_user_is_member = false
      return
    end
    @membership = Membership.find { |m| m.beer_club_id == @beer_club.id && m.user_id == current_user.id }
    if @membership.nil?
      @membership = Membership.new
      @membership.beer_club = @beer_club
      @current_user_is_member = false
      @application_exists = false
    else
      @current_user_is_member = @membership.confirmed
      @application_exists = !@membership.confirmed
    end

    @applications = @beer_club.applications.joins(:user).select("memberships.id,users.username")
  end

  # GET /beer_clubs/new
  def new
    @beer_club = BeerClub.new
  end

  # GET /beer_clubs/1/edit
  def edit
  end

  # POST /beer_clubs or /beer_clubs.json
  def create
    @beer_club  = BeerClub.new(beer_club_params)
    @membership = Membership.new beer_club: @beer_club, user: current_user

    # Koetetaan tallentaa klubi ja tehdä käyttäjästä jäsen; kummankin on onnistuttava, jottei synny tilannetta, jossa on esim. klubi ilman jäseniä
    saved_club = nil
    BeerClub.transaction do
      saved_club = @beer_club.save
      @membership.save
    end
    respond_to do |format|
      if saved_club
        format.html { redirect_to beer_club_url(@beer_club), notice: "Beer club was successfully created." }
        format.json { render :show, status: :created, location: @beer_club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_clubs/1 or /beer_clubs/1.json
  def update
    respond_to do |format|
      if @beer_club.update(beer_club_params)
        format.html { redirect_to beer_club_url(@beer_club), notice: "Beer club was successfully updated." }
        format.json { render :show, status: :ok, location: @beer_club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_clubs/1 or /beer_clubs/1.json
  def destroy
    @beer_club.destroy

    respond_to do |format|
      format.html { redirect_to beer_clubs_url, notice: "Beer club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer_club
    @beer_club = BeerClub.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def beer_club_params
    params.require(:beer_club).permit(:name, :founded, :city)
  end
end
