class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]
  before_action :check_if_already_member, only: %i[create]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = joinable_beer_clubs
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user
    @beer_clubs = joinable_beer_clubs

    respond_to do |format|
      if @membership.save
        format.html { redirect_to   beer_club_url(@membership), notice: "Welcome to the club #{current_user.username}!" }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to memberships_url, notice: "Membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Check if user is already in the beer club
  def check_if_already_member
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)

    return unless current_user.beer_clubs.map(&:id).include?(@membership.beer_club_id)

    redirect_to new_membership_url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id)
  end

  # Only list beer clubs the user is not a member of
  def joinable_beer_clubs
    joined_beer_clubs = current_user.beer_clubs.map(&:id)
    BeerClub.where.not(id: joined_beer_clubs)
  end
end
