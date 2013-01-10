module SendgridToolkit
  class AbstractSendgridClient

    def initialize(api_user = nil, api_key = nil)
      @api_user = api_user || SendgridToolkit.api_user || ENV['SMTP_USERNAME']
      @api_key = api_key || SendgridToolkit.api_key || ENV['SMTP_PASSWORD']

      raise SendgridToolkit::NoAPIUserSpecified if @api_user.nil? || @api_user.length == 0
      raise SendgridToolkit::NoAPIKeySpecified if @api_key.nil? || @api_key.length == 0
    end

    protected

    def api_post(module_name, action_name, opts = {})
      uri = URI.parse("https://#{BASE_URI}/#{module_name}.#{action_name}.json")
      conn = Faraday.new(uri) do |faraday|
        faraday.use Faraday::Request::UrlEncoded
        faraday.use Faraday::Response::ParseJson
        faraday.adapter Faraday.default_adapter
      end
      response = conn.post(uri.path, get_credentials.merge(opts))
      if response.status > 401
        raise(SendgridToolkit::SendgridServerError, "The sengrid server returned an error. #{response.body.inspect}")
      elsif has_error?(response.body) and
          response.body['error'].respond_to?(:has_key?) and
          response.body['error'].has_key?('code') and
          response.body['error']['code'].to_i == 401
        raise SendgridToolkit::AuthenticationFailed
      elsif has_error?(response.body)
        raise(SendgridToolkit::APIError, response.body['error'])
      end
      response.body
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
