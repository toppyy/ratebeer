module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    sum = ratings.map(&:score).reduce(:+)
    sum / ratings.count.to_f
  end
end
