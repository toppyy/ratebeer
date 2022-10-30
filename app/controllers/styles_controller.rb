class StylesController < ApplicationController
  before_action :set_style, only: %i[show edit update destroy]
  def index
    @styles = Style.all
  end

  def show
  end

  def new
  end

  def edit
  end

  # Common methods
  def set_style
    @style = Style.find(params[:id])
  end
end
