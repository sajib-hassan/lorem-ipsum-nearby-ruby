require "finleap_nearby/version"
require 'json'
require 'finleap_nearby/geo_calculator'
require 'finleap_nearby/customers'

module FinleapNearby
  class Error < StandardError; end
  class InvalidFilePath < Error; end
  class InvalidParams < Error; end
  class RequiredDataMissing < Error; end
end
