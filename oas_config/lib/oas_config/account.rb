module OasConfig
  class Account < OasConfig::BaseModel
    def self.base_path
      '/api/accounts/'
    end
  end
end
