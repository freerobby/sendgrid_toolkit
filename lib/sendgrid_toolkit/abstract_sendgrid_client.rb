module SendgridToolkit
  class AbstractSendgridClient
    
    def initialize(api_user = nil, api_key = nil)
      @api_user = (api_user.nil?) ? ENV['SMTP_USERNAME'] : api_user
      @api_key = (api_key.nil?) ? ENV['SMTP_PASSWORD'] : api_key
      
      raise SendgridToolkit::NoAPIUserSpecified if @api_user.blank?
      raise SendgridToolkit::NoAPIKeySpecified if @api_key.blank?
    end
    
    protected
    
    def api_post(module_name, action_name, opts = {})
      response = HTTParty.post("https://#{BASE_URI}/#{module_name}.#{action_name}.json?", :query => get_credentials.merge(opts), :format => :json)
      raise(SendgridToolkit::SendgridServerError, "The sengrid server returned an error. #{response.inspect}") if response.code > 401
      raise SendgridToolkit::AuthenticationFailed if has_error?(response) && response['error'].has_key?('code') && response['error']['code'].to_i == 401
      response
    end
    
    def get_credentials
      {:api_user => @api_user, :api_key => @api_key}
    end
    
    private
    def has_error?(response)
      response.kind_of?(Hash) && response.has_key?('error')
    end
  end
end