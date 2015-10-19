require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::NewsletterSendgridClient do
  specify do
    expect(SendgridToolkit::NewsletterSendgridClient).
      to be < SendgridToolkit::AbstractSendgridClient
  end

  describe '#api_post' do

    before { FakeWeb.clean_registry }

    it 'prepends newsletter to the base path' do
      opts = {a: 1}

      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/newsletter/lists/add\.json\?.*a=1|,
                                  :body => '{"message":"success"}')

      sendgrid_client = SendgridToolkit::NewsletterSendgridClient.new("fakeuser", "fakepass")

      expect(sendgrid_client.send(:api_post, "lists", "add", opts)).to eql({ 'message' => 'success' })
    end
  end
end
