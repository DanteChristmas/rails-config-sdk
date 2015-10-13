require 'active_model/callbacks'
require 'active_support/callbacks'

module OasConfig
  class BaseModel
    extend ActiveModel::Callbacks
    include OasConfig::Validations
    define_model_callbacks :fetch

    attr_accessor :dto

    def self.base_path
      raise "You must define a `base_path` class method on #{my_class}"
    end

    def initialize(data={})
      self.status = 200

      @dto = (data ||= {}).with_indifferent_access
    end

    def id
      @dto[:id]
    end

    def self.find(id, options={})
      config = OasConfig.configuration
      connection = OasConfig::Utilities.api_connection(config, my_class)

      url = Utilities.url_encode "#{base_path}#{id}"

      response = connection.get url, options

      instance = my_class.new
      instance.run_callbacks :fetch do
        instance.update_from_response(response)
      end
      instance
    end

    def self.all(options={}, &block)
      config = OasConfig.configuration
      connection = OasConfig::Utilities.api_connection(config, my_class)

      response = connection.get base_path, options

      collection = OasConfig::Collection.from_response my_class, response
      collection.each do |model|
        model.run_callbacks :fetch
      end
      collection
    end

    def update_attributes(attrs={})
      @dto.merge! attrs
    end

    def created_at
      OasConfig::Utilities.parse_api_time(create_date)
    end

    def updated_at
      OasConfig::Utilities.parse_api_time(last_modified_date)
    end

    def update_from_response(response)
      self.status = response.status
      if response.status == 200
        @dto = (response.body || {}).with_indifferent_access
      else
        @errors = response.body
      end
    end

    def to_json
      if self.valid?
        Oj.dump @dto.to_hash
      else
        Oj.dump self.errors
      end
    end

    def self.default_url_params
      {}
    end
  private

    # This method allows for us to dynamically bind classes within class methods of Amp::Model
    def self.my_class
      self
    end

    # This method allows for us to dynamically bind classes within instance methods of Amp::Model
    def my_class
      self.class
    end

    def method_missing(meth, *args, &block)
      # Converts method name from symbol
      method_name = meth.to_s

      # Checks to see if this is an assignment method. If so, throw an error
      super if method_name.match(/(\=|\?)$/)

      # Checks the dto for the camelized version of the method that was passed. AWESOME SAUCE
      @dto[method_name.camelize(:lower)]
    end
  end
end
