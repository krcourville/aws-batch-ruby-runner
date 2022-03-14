# frozen_string_literal: true

require 'easy_logging'
require 'dotenv/tasks'

require_relative 'lib/config'
require_relative 'lib/forecast'

EasyLogging.log_destination = $stdout
EasyLogging.level = ENV['LOG_LEVEL'] || 'WARN'

desc 'Validate code is ready for PR'
task check: %i[lint test]

desc 'Run unit tests'
task :test do |_t|
  sh %( rspec )
end

desc 'Lint'
task :lint do |_t|
  sh %( rubocop -A )
end

namespace :forecast do
  desc %(
      Set the location for weather forecasts (Stored in ./config/configuration.yaml)
      Usage:
          rake forecast:config[39.5939,-105.0105]
    )
  task :config, [:lat, :lon] do |_t, args|
    config = Config.new
    config.update do |cfg|
      cfg['forecast']['location']['lat'] = Float(args.lat)
      cfg['forecast']['location']['lon'] = Float(args.lon)
    end
  end

  desc %(
    "Prints today's forecast"
    Usage:
      rake forecast:today
    Output:
      11:00 AM, Sunny, 43F, 8 mph, N
      12:00 PM, Sunny, 46F, 9 mph, N
      01:00 PM, Sunny, 49F, 8 mph, N
      02:00 PM, Sunny, 50F, 8 mph, N
      03:00 PM, Sunny, 51F, 8 mph, NNE
  )
  task today: :dotenv do
    fc = Forecast.new
    puts fc.today
  end
end
