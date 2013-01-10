module SendgridToolkit
  class Statistics < AbstractSendgridClient
    def retrieve(options = {})
      response = api_post('stats', 'get', options)
      response.each {|r| r['date'] = Date.parse(r['date']) if r.kind_of?(Hash) && r.has_key?('date')}
      response
    end
    
    def retrieve_aggregate(options = {})
      options.merge! :aggregate => 1
      response = retrieve options
      if Hash === response
          to_ints(response)
      elsif Array === response
          response.each {|o| to_ints(o) }
      end
      response
    end

    def to_ints(resp)
      %w(bounces clicks delivered invalid_email opens repeat_bounces repeat_spamreports repeat_unsubscribes requests spamreports unsubscribes).each do |int_field|
        resp[int_field] = resp[int_field].to_i if resp.has_key?(int_field)
      end
    end
 
    def list_categories(options = {})
      options.merge! :list => true
      response = retrieve options
      response
    end
  end
end
