module TopN
  extend ActiveSupport::Concern
  class_methods do
    def top(how_many)
      all.sort_by{ |b| -b.average_rating }.take(how_many)
    end
  end
end
