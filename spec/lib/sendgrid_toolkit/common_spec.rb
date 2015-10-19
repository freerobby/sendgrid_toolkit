require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Common do

  before do
    class FakeClass < SendgridToolkit::AbstractSendgridClient
      include SendgridToolkit::Common
    end
    @fake_class = FakeClass.new("fakeuser", "fakepass")
  end

  it "creates a module_name method that returns the class name downcased" do
    expect(@fake_class.module_name).to eq("fakeclass")
  end

  it "does not choke if response does not have a 'message' field" do
    FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/fakeclass\.delete\.json\?.*email=.+|, :body => '{}')
    expect {
      @fake_class.delete :email => "user@domain.com"
    }.not_to raise_error
  end

  # this will only really test it on a computer that's on on utc.
  describe 'retrieve_with_timestamps' do
    it 'should parse the created date in utc' do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/fakeclass\.get\.json\?.*date=1|, :body => '[{"created":"2013-11-25 13:00:00"}]')
      fake_class = @fake_class.retrieve_with_timestamps
      expect(fake_class[0]['created'].utc.iso8601).to eq("2013-11-25T13:00:00Z")
    end
  end

end

