class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average_rating
        sum = ratings.map {|r| r.score}.reduce(:+)
        return sum/ratings.count.to_f
    end

    def to_s
        return "#{name} (#{brewery.name})"
    end
    
end