require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryBot.create :user }

  before :each do
    FactoryBot.create :brewery
    FactoryBot.create :style
    sign_in(username: "Pekka", password: "Foobar1")
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