module SendgridToolkit
  class List < AbstractSendgridClient
    
    def index(options={})
      response = api_post(nil ,'get')
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].inspect}") if response["message"] == "error"
      response
    end
  end
end
