# frozen_string_literal: true

require 'easy_logging'
require 'http'
require 'json'

module WeatherGov
  # Api client for api.weather.gov
  class ApiClient
    include EasyLogging

    def initialize
      @base_url = 'https://api.weather.gov'
      HTTP.default_options = HTTP::Options.new(
        headers: user_agent,
        features: {
          logging: {
            logger:
          }
        }
      )
    end

    # Resolve location data give a lat/lon coordinates
    def points(lat, lon)
      res = HTTP.get("#{@base_url}/points/#{lat},#{lon}")

      JSON.parse(res.to_s)
    end

    def forecast(grid_id, grid_x, grid_y)
      res = HTTP.get("#{@base_url}/gridpoints/#{grid_id}/#{grid_x},#{grid_y}/forecast/hourly")

      JSON.parse(res.to_s)
    end

    private

    def user_agent
      { 'User-Agent': "(aws-batch-ruby-runner, #{ENV['WEATHER_GOV_USER_AGENT']}" }
    end
  end
end
