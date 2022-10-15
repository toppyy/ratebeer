require 'rails_helper'

include Helpers

describe "Beer" do
  before :each do
    FactoryBot.create :brewery
  end


  it "can be created with a non-empty name" do
    visit new_beer_path

    fill_in('beer_name', with: 'Uus bisse')
    expect{
        click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "can not be created with an empty name" do
    visit new_beer_path

    expect{
        click_button('Create Beer')
    }.to change{Beer.count}.by(0)
  end


end