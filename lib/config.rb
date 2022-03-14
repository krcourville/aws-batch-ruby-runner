# frozen_string_literal: true

require 'pathname'
require 'yaml'
require 'ostruct'

def config_defaults
  {
    'forecast' => {
      'location' => {
        'lat' => nil,
        'lon' => nil
      }
    }
  }
end

# Centralized configuration manager
class Config
  def initialize
    @config_hash = Marshal.load(Marshal.dump(config_defaults))
    cwd = Dir.getwd
    @config_path = Pathname.new(cwd).join('config/configuration.yaml')
    return unless @config_path.exist?

    yaml = YAML.load_file(@config_path) || {}
    @config_hash.merge! yaml
  end

  # Perform an update against configuration
  def update(&block)
    block.call(@config_hash)
    yaml_data = YAML.dump(@config_hash)
    File.write(@config_path, yaml_data)
  end

  # Retrieve configuration as a hash
  def v(*args)
    args_s = args.map(&:to_s)
    @config_hash.dig(*args_s)
  end
end
