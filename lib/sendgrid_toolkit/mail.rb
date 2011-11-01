module SendgridToolkit
  class Mail < AbstractSendgridClient
    def send_mail(options = {})
      response = api_post('mail', 'send', options)
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].inspect}") if response["message"] == "error"
      response
    end
  end
end
