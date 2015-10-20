module OasConfig
  class Account < OasConfig::BaseModel
    def self.base_path
      '/api/accounts/'
    end

    def self.find(id, options={})
      @result = super id, options
      if options[:include_gulp_config]
        gulp_json = @result.assets.map {|a| "#{a[:component_name]}/#{a[:version]}/#{a[:file_name]}"}
        OasConfig::Utilities.write_json(gulp_json.to_json, OasConfig.configuration.gulp_config_path, 'asset-config.json')
      end

      @result
    end

    def self.system_account(options={})
      params = {
        search_by_org_code: true,
        include_assets: true,
        include_amp_config: true,
        include_feature_toggles: true,
        org_code: OasConfig.configuration.organization_code
      }
      params[:force] = options[:force] if options[:force]
      params[:include_gulp_config] = options[:include_gulp_config] if options[:include_gulp_config]

      self.find(params[:org_code], params)
    end
  end
end
