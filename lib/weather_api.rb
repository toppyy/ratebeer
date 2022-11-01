
class WeatherApi
    def self.weather_in(city)
      city = city.downcase
      Rails.cache.fetch(city+"_weather", expires_in: 1.week) { get_weather_in(city) }
    end
  
    def self.get_weather_in(city)
      url = "https://www.meteosource.com/api/v1/free/point?place_id=#{ERB::Util.url_encode(city)}&sections=current&language=en&units=auto&key=#{key}"
      response = HTTParty.get url
      parsed_response = response.parsed_response
      return nil if parsed_response['current'].nil?
      weather = parsed_response["current"]
      return Weather.new(weather)
    end
  
    def self.key
      return nil if Rails.env.test?
      raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?
  
      ENV.fetch('WEATHER_APIKEY')
    end
end
  


