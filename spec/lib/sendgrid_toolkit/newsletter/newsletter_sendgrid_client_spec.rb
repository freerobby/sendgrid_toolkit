require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::NewsletterSendgridClient do
  specify do
    SendgridToolkit::NewsletterSendgridClient.
      should be < SendgridToolkit::AbstractSendgridClient
  end

  describe '#api_post' do

    before { FakeWeb.clean_registry }

    it 'prepends newsletter to the base path' do
      opts = {a: 1}

      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/newsletter/lists/add\.json\?.*a=1|,
                                  :body => '{"message":"success"}')

      sendgrid_client = SendgridToolkit::NewsletterSendgridClient.new("fakeuser", "fakepass")

      sendgrid_client.send(:api_post, "lists", "add", opts).should eql({ 'message' => 'success' })
    end
  end
end
