# frozen_string_literal: true

require 'easy_logging'
require_relative 'config'
require_relative 'weather_gov/api'
require 'date'

# Service for retrieve weather forecast data
class Forecast
  include EasyLogging

  def initialize
    @config = Config.new
    @weather = WeatherGov::ApiClient.new
  end

  def today
    grid_id, grid_x, grid_y = resolve_location
    logger.info { "Getting forecast for #{grid_id} #{grid_x}, #{grid_y}" }
    res = @weather.forecast(grid_id, grid_x, grid_y)
    periods = res.dig('properties', 'periods')[0..23]

    periods.map do |p|
      [
        Time.parse(p['startTime']).strftime('%I:%M %p'),
        p['shortForecast'],
        "#{p['temperature']}#{p['temperatureUnit']}",
        p['windSpeed'],
        p['windDirection']
      ].join(', ')
    end
  end

  private

  def resolve_location
    lat = @config.v(:forecast, :location, :lat)
    lon = @config.v(:forecast, :location, :lon)
    raise('Location is not initialized. Run configure() first.') unless lat && lon

    res = @weather.points(lat, lon)
    props = res['properties']
    grid_id = props['gridId']
    grid_x = props['gridX']
    grid_y = props['gridY']

    [grid_id, grid_x, grid_y]
  end
end
