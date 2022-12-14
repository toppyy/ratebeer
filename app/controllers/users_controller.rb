class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy toggle_activity]
  # except onlyn sijaan, jotta uudet metodit ovat oletuksena vain admin ja käyttäjän itse käytettävissä
  before_action :check_user, except: %i[index show new create toggle_activity]
  before_action :ensure_is_admin, except: %i[edit update destroy index show new create toggle_activity]

  # GET /users or /users.json
  def index
    @users = User.includes(:ratings).all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if user_params[:username].nil? && @user == current_user && @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    # Destroying a user means also loggin out
    session.destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST
  def toggle_activity
    @user.update_attribute :active, !@user.active
    new_status = @user.active? ? "active" : "closed"
    redirect_to @user, notice: "account status changed to #{new_status}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  # Check user in parameters equals to user of the session
  # if not, render a message of authorized access
  def check_user
    user_is_not_logged_in = @user != current_user
    return true unless user_is_not_logged_in

    render status: :unauthorized, json: { error: "You are not authorized to access this resource." }
  end
end
