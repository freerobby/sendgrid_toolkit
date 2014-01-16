module SendgridToolkit
  class Unsubscribes < AbstractSendgridClient
    def add(options = {})
      response = api_post('unsubscribes', 'add', options)
      raise UnsubscribeEmailAlreadyExists if response['message'].include?('already exists')
      response
    end
    
    def delete(options = {})
      response = api_post('unsubscribes', 'delete', options)
      raise UnsubscribeEmailDoesNotExist if response['message'].include?('does not exist')
      response
    end
    
    def retrieve(options = {})
      response = api_post('unsubscribes', 'get', options)
      response
    end
    
    def retrieve_with_timestamps(options = {})
      options.merge! :date => 1
      response = retrieve options
      response.each do |unsubscribe|
        unsubscribe['created'] = Time.parse(unsubscribe['created']+' UTC') if unsubscribe.has_key?('created')
      end
      response
    end
  end
end