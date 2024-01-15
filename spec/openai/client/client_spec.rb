RSpec.describe OpenAI::Client do
  let(:default_timeout) { OpenAI::Configuration::DEFAULT_REQUEST_TIMEOUT }

  it "can be initialized" do
    expect { OpenAI::Client.new }.not_to raise_error
  end

  describe ".get" do
    it "sets the timeout in the connection" do
      expect(Faraday).to receive(:new).with(
        hash_including(request: { timeout: default_timeout })
      ).and_call_original
      expect_any_instance_of(Faraday::Connection).to receive(:get)

      OpenAI::Client.new.get(path: "/abc")
    end
  end

  describe ".json_post" do
    it "sets the timeout in the connection" do
      expect(Faraday).to receive(:new).with(
        hash_including(request: { timeout: default_timeout })
      ).and_call_original
      expect_any_instance_of(Faraday::Connection).to receive(:post)

      OpenAI::Client.new.json_post(path: "/abc", parameters: { foo: :bar })
    end
  end

  describe ".multipart_post" do
    it "sets the timeout in the connection" do
      expect(Faraday).to receive(:new).with(
        hash_including(request: { timeout: default_timeout })
      ).and_call_original
      expect_any_instance_of(Faraday::Connection).to receive(:post)

      OpenAI::Client.new.multipart_post(path: "/abc")
    end
  end

  describe ".delete" do
    it "sets the timeout in the connection" do
      expect(Faraday).to receive(:new).with(
        hash_including(request: { timeout: default_timeout })
      ).and_call_original
      expect_any_instance_of(Faraday::Connection).to receive(:delete)

      OpenAI::Client.new.delete(path: "/abc")
    end
  end

  context "with a block" do
    let(:client) do
      OpenAI::Client.new do |client|
        client.response :logger, ::Logger.new(STDOUT), bodies: true
      end
    end

    it "sets the logger" do
      connection = Faraday.new
      client.faraday_config.call(connection)
      expect(connection.builder.handlers).to include Faraday::Response::Logger
    end
  end
end
