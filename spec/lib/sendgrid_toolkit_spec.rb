require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe SendgridToolkit do
  subject { described_class }
  describe ".base_uri" do
    it "returns value set by user" do
      subject.base_uri = "foo"
      expect(subject.base_uri).to eq("foo")
    end

    it "finds ENV variable" do
      subject.base_uri = nil
      ENV['SENDGRID_API_BASE_URI'] = "bar"
      expect(subject.base_uri).to eq("bar")
    end

    it "returns default value" do
      subject.base_uri = nil
      ENV['SENDGRID_API_BASE_URI'] = nil
      expect(subject.base_uri).to eq(subject::BASE_URI)
    end
  end
end
