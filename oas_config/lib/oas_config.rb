require "faraday"
require 'oj'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require "forwardable"

require "oas_config/version"
require "amp/utilities"
require "amp/validations"
require "amp/middleware/parse_json"

module OasConfig
  class << self
    attr_accessor :configuration, :logger
    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end
  end


  class Configuration
    attr_accessor :endpoint_url,
                  :log_requests,
                  :timeout
  end
end
