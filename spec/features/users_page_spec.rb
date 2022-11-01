require 'rails_helper'

include Helpers

describe "User" do
  
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "favorite" do
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
      # Create a not so nice beer to test that the favorite is picked correctly
      create_beer_with_rating({ user: @user }, 1) 
    end

    it "beer style is displayed correctly" do
      best_style = FactoryBot.create :style
      create_beer_with_rating_and_style({ user: @user }, 3, best_style)
      visit user_path(@user)
      
      expect(page).to have_content 'Favorite beer style is: ' + best_style.name
    end

    it "brewery is displayed correctly" do
      brewery = FactoryBot.create :brewery, name: "bestbrew"
      create_beer_with_rating_and_brewery({ user: @user }, 3, brewery.name)
      visit user_path(@user)

      expect(page).to have_content 'Favorite brewery is: ' + brewery.name
    end
  end
end