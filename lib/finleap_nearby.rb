require "finleap_nearby/version"
require "json"
require "finleap_nearby/extension"
require "finleap_nearby/configuration"
require "finleap_nearby/geo_calculator"
require "finleap_nearby/customers"

module FinleapNearby
  class Error < StandardError; end

  class InvalidFilePath < Error; end

  class InvalidParams < Error; end

  class RequiredDataMissing < Error; end

  class InvalidSortKey < Error; end

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
end
