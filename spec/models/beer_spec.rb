require 'rails_helper'

RSpec.describe Beer, type: :model do


  describe "with a proper brewery" do

    let(:test_brewery){Brewery.new name: "Stadin panimo", year: 2002}
    
    it "and a name and style is saved" do
      beer = Beer.create name: "bisse", style: "weizen", brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "is not saved without a name" do
      beer = Beer.create style: "weizen", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
      beer = Beer.create name: "kalja", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

  end
end