module SendgridToolkit
  class Statistics < AbstractSendgridClient
    def retrieve(options = {})
      response = api_post('stats', 'get', options)
      response
    end
    
    def retrieve_aggregate(options = {})
      options.merge! :aggregate => 1
      response = retrieve options
      %w(bounces clicks delivered invalid_email opens repeat_bounces repeat_spamreports repeat_unsubscribes requests spamreports unsubscribes).each do |int_field|
        response[int_field] = response[int_field].to_i if response.has_key?(int_field)
      end
      response
    end
    
    def list_categories(options = {})
      options.merge! :list => true
      response = retrieve options
      response
    end
  end
end