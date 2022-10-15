require 'rails_helper'
include Helpers

describe "Rating" do
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
    let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
    let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
    let!(:user) { FactoryBot.create :user }

    before :each do
        sign_in(username: "Pekka", password: "Foobar1")
    end

    it "when given, is registered to the beer and user who is signed in" do
        visit new_rating_path
        select('iso 3', from: 'rating[beer_id]')
        fill_in('rating[score]', with: '15')

        expect{
        click_button "Create Rating"
        }.to change{Rating.count}.from(0).to(1)

        expect(user.ratings.count).to eq(1)
        expect(beer1.ratings.count).to eq(1)
        expect(beer1.average_rating).to eq(15.0)
    end

    it "and count of ratings are displayed" do

        b1 = create_beer_with_rating({ user: user }, 11)
        b2 = create_beer_with_rating({ user: user }, 2)
        b3 = create_beer_with_rating({ user: user }, 4)
        visit ratings_path

        expect(page).to have_content b1.ratings.first.to_s
        expect(page).to have_content b2.ratings.first.to_s
        expect(page).to have_content b3.ratings.first.to_s

        expect(page).to have_content "Ratings: 3"
    end

    it "by the user is displayed in the user-page (and none others)" do

        another_user = FactoryBot.create :user, username: "not-Pekka"

        b1 = create_beer_with_rating({ user: user }, 11)
        b2 = create_beer_with_rating({ user: another_user }, 5)

        visit user_path(user)

        expect(page).to have_content b1.ratings.first.to_s
        expect(page).not_to have_content b2.ratings.first.to_s
    end

    it "is removed from the database when deleted" do
        b1 = create_beer_with_rating({ user: user }, 11)
        visit user_path(user)

        puts page.html

    end

end