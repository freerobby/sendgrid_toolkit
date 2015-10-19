require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Unsubscribes do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Unsubscribes.new("fakeuser", "fakepass")
  end

  describe "#retrieve" do
    it "returns array of unsubscribed email addresses" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/unsubscribes\.get\.json\?|, :body => '[{"email":"user@domain.com"},{"email":"user2@domain2.com"},{"email":"user3@domain2.com"}]')
      emails = @obj.retrieve
      expect(emails[0]['email']).to eq("user@domain.com")
      expect(emails[1]['email']).to eq("user2@domain2.com")
      expect(emails[2]['email']).to eq("user3@domain2.com")
    end
  end
  describe "#retrieve_with_timestamps" do
    it "parses timestamps" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/unsubscribes\.get\.json\?.*date=1|, :body => '[{"email":"user@domain.com","created":"2010-03-03 11:00:00"},{"email":"user2@domain2.com","created":"2010-03-04 21:00:00"},{"email":"user3@domain2.com","created":"2010-03-05 23:00:00"}]')
      emails = @obj.retrieve_with_timestamps
      0.upto(2) do |index|
        expect(emails[index]['created'].kind_of?(Time)).to be_truthy
      end
      expect(emails[0]['created'].asctime).to eq("Wed Mar  3 11:00:00 2010")
      expect(emails[1]['created'].asctime).to eq("Thu Mar  4 21:00:00 2010")
      expect(emails[2]['created'].asctime).to eq("Fri Mar  5 23:00:00 2010")
    end
  end

  describe "#add" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/unsubscribes\.add\.json\?.*email=.+|, :body => '{"message":"success"}')
      expect {
        @obj.add :email => "user@domain.com"
      }.not_to raise_error
    end
    it "raises error when email already exists" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/unsubscribes\.add\.json\?.*email=.+|, :body => '{"message":"Unsubscribe email address already exists"}')
      expect {
        @obj.add :email => "user@domain.com"
      }.to raise_error SendgridToolkit::UnsubscribeEmailAlreadyExists
    end
  end

  describe "#delete" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/unsubscribes\.delete\.json\?.*email=.+|, :body => '{"message":"success"}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.not_to raise_error
    end
    it "raises error when email address does not exist" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/unsubscribes\.delete\.json\?.*email=.+|, :body => '{"message":"Email does not exist"}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.to raise_error SendgridToolkit::UnsubscribeEmailDoesNotExist
    end
  end
end
