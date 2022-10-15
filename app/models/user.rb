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
end
