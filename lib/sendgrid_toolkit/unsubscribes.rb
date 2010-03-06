module SendgridToolkit
  class Unsubscribes < AbstractSendgridClient
    def self.add(options = {})
      response = HTTParty.get("https://#{BASE_URI}/unsubscribes.add.json?", :query => get_credentials.merge(options), :format => :json)
      raise UnsubscribeEmailAlreadyExists if response['message'].include?('already exists')
      response
    end
    
    def self.delete(options = {})
      response = HTTParty.get("https://#{BASE_URI}/unsubscribes.delete.json?", :query => get_credentials.merge(options), :format => :json)
      raise UnsubscribeEmailDoesNotExist if response['message'].include?('does not exist')
      response
    end
    
    def self.retrieve(options = {})
      response = HTTParty.get("https://#{BASE_URI}/unsubscribes.get.json?", :query => get_credentials.merge(options), :format => :json)
      response.each do |unsubscribe|
        unsubscribe['created'] = Time.parse(unsubscribe['created']) if unsubscribe.has_key?("created")
      end
      response
    end
  end
end