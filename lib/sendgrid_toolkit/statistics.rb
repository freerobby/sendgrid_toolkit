module SendgridToolkit
  class Statistics < AbstractSendgridClient
    def advanced(data_type, start_date, options = {})
      options.merge! :data_type => data_type
      options.merge! :start_date => format_date(start_date, options)

      response = api_post('stats', 'getAdvanced', options)
      response.each { |r| r['date'] = Date.parse(r['date']) if r.kind_of?(Hash) && r.has_key?('date') }
      response
    end

    def retrieve(options = {})
      response = api_post('stats', 'get', options)
      response.each {|r| r['date'] = Date.parse(r['date']) if r.kind_of?(Hash) && r.has_key?('date')}
      response
    end

    def retrieve_aggregate(options = {})
      options.merge! :aggregate => 1
      response = retrieve options
      if Hash === response.parsed_response
          to_ints(response.parsed_response)
      elsif Array === response.parsed_response
          response.parsed_response.each {|o| to_ints(o) }
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

    private

    def format_date(date, options = {})
      if date.is_a? Date
        case options[:aggregated_by].to_s
        when 'week'
          date = date.strftime("%Y-%V")
        when 'month'
          date = date.strftime("%Y-%m")
        else
          date = date.strftime("%Y-%m-%d")
        end
      end

      date
    end
  end
end
