module RatingAverage
    extend ActiveSupport::Concern
   
    def average_rating
        sum = ratings.map {|r| r.score}.reduce(:+)
        return sum/ratings.count.to_f
    end
end