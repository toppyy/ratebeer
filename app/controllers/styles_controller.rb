class StylesController < ApplicationController
  before_action :set_style, only: %i[show edit update destroy]
  before_action :ensure_is_admin, only: [:destroy]

  def index
    @styles = Style.all
  end

  def show
  end

  def new
  end

  def edit
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    @style.destroy

    respond_to do |format|
      format.html { redirect_to styles_url, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Common methods
  def set_style
    @style = Style.find(params[:id])
  end
end
