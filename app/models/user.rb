class User < ApplicationRecord
  include RatingAverage
  has_many :ratings

  def to_s
    "#{username}"
  end
end
