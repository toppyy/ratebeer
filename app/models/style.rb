class Style < ApplicationRecord
  include RatingAverage, TopN
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name.to_s
  end
end
