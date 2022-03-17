# frozen_string_literal: true

require 'date'

require 'aws-sdk-s3'
require 'easy_logging'

require_relative 'config'
require_relative 'weather_gov/api'

# Service for retrieve weather forecast data
class Forecast
  include EasyLogging

  def initialize
    @config = Config.new
    @weather = WeatherGov::ApiClient.new
  end

  def save(_bucket_name)
    bucket_name = ENV['BUCKET_NAME']
    logger.info { "using bucket #{bucket_name}" }
    object = Aws::S3::Object.new(bucket_name, 'forecast.txt')
    data = forecast.join('\n')
    object.put(body: data)
    logger.info { "Object put sucessfully: s3://#{bucket_name}/#{object.key}" }
    true
  rescue Aws::Errors::ServiceError => e
    logger.error { "Failed to put object: s3://#{bucket_name}/#{object.key}. #{e.message}" }
    false
  end

  def today
    forecast.join('\n')
  end

  private

  def forecast
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
