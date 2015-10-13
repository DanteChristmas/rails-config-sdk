module OasSchool
  module AccountConfig
    module Utilities
      def self.parse_api_time(time_string)
        return nil if time_string.nil? || time_string.empty?

        Time.parse time_string
      end

      def self.api_connection(config, clazz=nil)
        config ||= OasConfig.configuration

        raise 'No OAS configuration provided!' unless config

        params = {}

        params.merge!(clazz.default_url_params) if clazz

        Faraday.new config[:endpoint_url], params: params do |faraday|
          faraday.headers['Authorization'] = config.authorization_header if config.authorization_header
          faraday.headers['Content-Type'] = 'application/json'
          faraday.headers['Accept-Encoding'] = 'compress'
          faraday.headers['Connection'] = 'keep-alive'
          faraday.options.timeout = config.timeout if config.timeout

          faraday.use config.faraday_middleware if config.faraday_middleware
          faraday.request :url_encoded

          faraday.use OasConfig::Middleware
          #TODO: Implement a logger for these faraday requests
          # faraday.response :logger if config[:log_requests]

          faraday.adapter Faraday.default_adapter
        end
      end

      def self.url_encode(uri)
        URI.encode(uri)
      end
    end
  end
end
