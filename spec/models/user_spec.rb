require 'rails_helper'
include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer
  
      user.ratings << rating
      user.ratings << rating2
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with an improper password" do

    it "is not saved because it's too short" do
      user = User.create username: "Pekka", password: "Si2", password_confirmation: "Si2" 

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is not saved because it consists of only lowercase letters" do
      user = User.create username: "Pekka", password: "salasana", password_confirmation: "salasana" 

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user }, 7 )
      best = create_beer_with_rating({ user: user }, 25 )
    
      expect(user.favorite_beer).to eq(best)
    end
  end


  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      expected_style = "test_style"
      create_beer_with_rating_and_style({ user: user}, 10, expected_style)
      expect(user.favorite_style).to eq(expected_style)
    end

    it "is the one with highest rating if several rated" do
      expected_style = "test_style"
      create_beer_with_rating_and_style({ user: user}, 10, "fail")
      create_beer_with_rating_and_style({ user: user}, 15, expected_style)
      create_beer_with_rating_and_style({ user: user}, 9, "fail")

      expect(user.favorite_style).to eq(expected_style)
    end

  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      expected_brewery = "test_brew"
      favorite = create_beer_with_rating_and_brewery({ user: user}, 10, expected_brewery)
      expect(user.favorite_brewery).to eq(favorite.brewery)
    end

    it "is the one with highest rating if several rated" do
      expected_brewery = "test_brew"
      create_beer_with_rating_and_brewery({ user: user}, 15, "fail")
      create_beer_with_rating_and_brewery({ user: user}, 15, "fail")
      create_beer_with_rating_and_brewery({ user: user}, 15, expected_brewery)
      favorite = create_beer_with_rating_and_brewery({ user: user}, 16, expected_brewery)
      

      expect(user.favorite_brewery).to eq(favorite.brewery)
    end

  end

end
