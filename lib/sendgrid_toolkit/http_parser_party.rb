# Custom parser to deal with the sendgrid server returning HTML when JSON is requested.
module SendgridToolkit
  class HTTParserParty
    include HTTParty

    # Only support Atom
    class Parser::OnlyJson < HTTParty::Parser
      SupportedFormats = { "application/json" => :json }

      protected

      # perform atom parsing on body
      def json
        begin
          super
        rescue JSON::ParserError => e
          return "#{body} - SendgridToolkit warning: We requested JSON, but the response generated the following error when we tried parsing it: #{e.class}: #{e}"
        end
      end
    end

    parser Parser::OnlyJson
  end
end
