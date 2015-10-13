module OasConfig
  class Account < OasConfig::BaseModel
    def self.base_path
      '/api/accounts/'
    end

    def self.system_account(force=false)
      params = {
        :search_by_org_code: true,
        include_assets: true,
        org_code: OasConfig.configuration.organization_code,
        force: force
      }
      self.find(params[:org_code], params)
    end
  end
end
