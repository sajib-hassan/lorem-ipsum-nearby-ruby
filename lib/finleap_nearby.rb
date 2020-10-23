require "finleap_nearby/version"
require 'json'
require 'finleap_nearby/geo_calculator'
require 'finleap_nearby/customers'

module FinleapNearby
  class Error < StandardError; end

  class InvalidFilePath < Error; end

  class InvalidParams < Error; end

  class RequiredDataMissing < Error; end

  class << self
    attr_accessor :configuration
  end

  def self.config_defaults
    self.configuration ||= Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :search_radius, :search_radius_unit, :data_file_path, :center_point, :customer_data_keys

    DATA_FILE_PATH     = "data/customers.json"
    SEARCH_RADIUS      = 100.00
    SEARCH_RADIUS_UNIT = :km

    # The GPS coordinates for Berlin office are 52.508283, 13.329657
    CENTER_POINT = [52.508283, 13.329657]

    CUSTOMER_DATA_KEYS = ["user_id", "name", "latitude", "longitude"]

    def initialize
      @search_radius      = SEARCH_RADIUS
      @search_radius_unit = SEARCH_RADIUS_UNIT
      @data_file_path     = DATA_FILE_PATH
      @center_point       = CENTER_POINT
      @customer_data_keys = CUSTOMER_DATA_KEYS
    end
  end
end
