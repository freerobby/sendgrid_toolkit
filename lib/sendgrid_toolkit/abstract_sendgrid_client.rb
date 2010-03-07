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
      HTTParty.post("https://#{BASE_URI}/#{module_name}.#{action_name}.json?", :query => get_credentials.merge(opts), :format => :json)
    end
    
    def get_credentials
      {:api_user => @api_user, :api_key => @api_key}
    end
  end
end