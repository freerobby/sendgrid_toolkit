module SendgridToolkit
  class AbstractSendgridClient
    protected
    def self.get_credentials
      {:api_user => ENV['SMTP_USERNAME'], :api_key => ENV['SMTP_PASSWORD']}
    end
  end
end