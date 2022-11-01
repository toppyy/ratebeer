require 'rails_helper'

describe "Places" do
  
  let(:test_location) {"kumpula"}

  before :each do    
    allow(WeatherApi).to receive(:weather_in).with(test_location).and_return(
      Weather.new({ "summary": "Warm & fuzzy", "temperature": "35" })
    )
  end

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with(test_location).and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
  

    visit places_path
    fill_in('city', with: test_location)
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown at the page" do

    expected_placenames = ["Oljenkorsi", "Gurula", "Herkku-Haarukka"]
    expected_places = expected_placenames.map { |name| Place.new( name: name, id: 1 ) }

    allow(BeermappingApi).to receive(:places_in).with(test_location).and_return(expected_places)

    visit places_path
    fill_in('city', with: test_location)
    click_button "Search"
    
    expected_placenames.map { |name| expect(page).to have_content name }
  end

  it "if none are returned by the API, it is indicated in a notice" do

    place = test_location

    allow(BeermappingApi).to receive(:places_in).with(place).and_return([])

    visit places_path
    fill_in('city', with: place)
    click_button "Search"
    
    expect(page).to have_content 'No locations in ' + place
  end

  it "display weather" do

    rainy_place = "england"
    allow(BeermappingApi).to receive(:places_in).with(rainy_place).and_return(
      [ Place.new( name: "Old english pub", id: 1 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with(rainy_place).and_return(
      Weather.new({"summary": "Wet,wet,wet", "temperature": "5" })
    )

    visit places_path
    fill_in('city', with: rainy_place)
    click_button "Search"
    
    expect(page).to have_content 'Wet,wet,wet. Temperature 5'
  end

end