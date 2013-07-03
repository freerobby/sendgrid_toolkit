module SendgridToolkit
  class Mail < AbstractSendgridClient
    def send_mail(options = {}, body = {})
      response = api_post('mail', 'send', options, body)
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].inspect}") if response["message"] == "error"
      response
    end
  end
end
