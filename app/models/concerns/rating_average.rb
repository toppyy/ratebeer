module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0.0 if ratings.empty?

    sum = ratings.map(&:score).reduce(:+)
    sum / ratings.count.to_f
  end
end
