require "finleap_nearby/version"
require "json"
require "finleap_nearby/extension"
require "finleap_nearby/config"
require "finleap_nearby/geo_calculator"
require "finleap_nearby/customers"

module FinleapNearby
  class Error < StandardError; end

  class InvalidFilePath < Error; end

  class InvalidParams < Error; end

  class RequiredDataMissing < Error; end

  class InvalidSortKey < Error; end

  class << self
    attr_writer :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end

  def self.configure
    yield(config)
  end
end
