module SendgridToolkit
  class MarketingEmail < AbstractSendgridClient
    
    def index(options={})
      response = marketing_request(nil ,'list')
      JSON.parse response.body
    end

  end
end
