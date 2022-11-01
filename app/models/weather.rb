class Weather < OpenStruct

    def to_s
        "#{summary}. Temperature #{temperature}"
    end
end
  