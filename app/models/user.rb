class User < ApplicationRecord
  include RatingAverage
  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 }, format: { with: /[A-Z]+.*\d|\d.*[A-Z]+/, message: "must contain at least a single capital letter (A-Z) and a digit" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  def to_s
    username.to_s
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def favorite_style
    return nil if ratings.empty?

    favorite =  ratings.
                joins(:beer).
                group("beers.style_id").
                select("avg(score) as avg,style_id").
                order(avg: :desc).first
    Style.find(favorite.style_id)
  end

  def favorite_brewery
    return nil if ratings.empty?

    fav_brewery = ratings.
                  joins(:beer).
                  group("beers.brewery_id").
                  select("avg(score) as avg,brewery_id").
                  order(avg: :desc).first
    Brewery.find(fav_brewery.brewery_id)
  end
end
