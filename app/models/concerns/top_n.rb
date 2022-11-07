module TopN
    extend ActiveSupport::Concern    
    class_methods do
        def top(n)
            all.sort_by{ |b| -b.average_rating }.take(n)
        end
    end
end
  