require "faraday"
require 'oj'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require "forwardable"

require "oas_config/version"
require "oas_config/utilities"
require "oas_config/validations"
require "oas_config/middleware"
require "oas_config/collection"
require "oas_config/base_model"
require "oas_config/account"

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
                  :timeout,
                  :authorization_header,
                  :faraday_middleware
  end
end
