require 'faraday_middleware'

module OasConfig
  class Middleware < FaradayMiddleware::ParseJson
    define_parser do |body|
      begin
        Oj.load(body, mode: :object)
      rescue Exception => e
        {
          "developerMessage" => "Something is not configured correctly: #{e.message}",
          "body" => body
        }
      end
    end
  end
end
