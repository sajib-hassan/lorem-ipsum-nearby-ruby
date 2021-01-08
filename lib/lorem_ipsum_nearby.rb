require "lorem_ipsum_nearby/version"
require "json"
require "lorem_ipsum_nearby/extension"
require "lorem_ipsum_nearby/config"
require "lorem_ipsum_nearby/geo_calculator"
require "lorem_ipsum_nearby/customers"

module LoremIpsumNearby
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
