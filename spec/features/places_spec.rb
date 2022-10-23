require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown at the page" do

    expected_placenames = ["Oljenkorsi", "Gurula", "Herkku-Haarukka"]
    expected_places = expected_placenames.map { |name| Place.new( name: name, id: 1 ) }

    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(expected_places)

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    
    expected_placenames.map { |name| expect(page).to have_content name }
  end

  it "if none are returned by the API, it is indicated in a notice" do

    place = 'kumpula'

    allow(BeermappingApi).to receive(:places_in).with(place).and_return([])

    visit places_path
    fill_in('city', with: place)
    click_button "Search"
    
    expect(page).to have_content 'No locations in ' + place
  end

end