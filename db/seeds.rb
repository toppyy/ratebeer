# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)



s1 = Style.create name: "European Lager", description: "Similar to Munich Helles, many European countries reacted to the popularity of early pale lagers by brewing their own. Hop flavor is significant and of noble varieties, bitterness is moderate, and both are backed by a solid malt body and sweet notes from an all-malt base."
s2 = Style.create name: "Hefeweizen", description: "A south German style of wheat beer (weissbier) typically made with a ratio of 50 percent barley to 50 percent wheat. Sometimes the percentage of wheat is even higher. 'Hefe' means 'with yeast,' hence the beer's unfiltered and cloudy appearance. The particular ale yeast used produces unique esters and phenols of banana and cloves with an often dry and tart edge, some spiciness, and notes of bubblegum or apples. Hefeweizens are typified by little hop bitterness, and a moderate level of alcohol. Often served with a lemon wedge (popularized by Americans), to cut the wheat or yeasty edge, some may find this to be either a flavorful snap or an insult that can damage the beer's taste and head retention."
s3 = Style.create name: "American Porter", description: "Inspired by the storied English Porter, the American Porter tends to make its own rules. With plenty of innovation and originality brewers in the US have taken this style to a new level, whether it's highly hopping the brew or adding coffee or chocolate to complement the highly roasted and burnt flavor associated with this type of beer. Some are even barrel aged in bourbon or whiskey barrels. The color could be medium brown to inky black and the range of hop bitterness is also quite wide, but most are balanced. And quite a few easy drinking session Porters can be found as well."
s4 = Style.create name: "English Pale Ale", description: "The English Pale Ale can be traced back to the 19th century and the city of Burton-upon-Trent, a place with an abundance of hard water, rich in calcium sulfate. As well as enhancing a beer's hop bitterness, this hard water helps achieve clarity. English Pale Ale can fall anywhere on the color spectrum between golden and reddish amber and should generally have good head retention. A mix of fruity, hoppy, earthy, buttery, and malty aromas and flavors can be found in the sip, not unlike a classic Bitter. Traditionally all ingredients are English in origin."


b1 = Brewery.create name: "Koff", year: 1897
b2 = Brewery.create name: "Malmgard", year: 2001
b3 = Brewery.create name: "Weihenstephaner", year: 1040

b1.beers.create name: "Iso 3", style: s1
b1.beers.create name: "Karhu", style: s1
b1.beers.create name: "Tuplahumala", style: s1
b2.beers.create name: "Huvila Pale Ale", style: s4
b2.beers.create name: "X Porter", style: s3
b3.beers.create name: "Hefeweizen", style: s2
b3.beers.create name: "Helles", style: s1