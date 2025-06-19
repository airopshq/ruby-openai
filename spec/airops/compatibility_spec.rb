RSpec.describe "compatibility" do
  context "for moved constants" do
    describe "::Airops::Ruby::OpenAI::VERSION" do
      it "is mapped to ::Airops::OpenAI::VERSION" do
        expect(Airops::Ruby::OpenAI::VERSION).to eq(Airops::OpenAI::VERSION)
      end
    end

    describe "::Airops::Ruby::OpenAI::Error" do
      it "is mapped to ::Airops::OpenAI::Error" do
        expect(Airops::Ruby::OpenAI::Error).to eq(Airops::OpenAI::Error)
        expect(Airops::Ruby::OpenAI::Error.new).to be_a(Airops::OpenAI::Error)
        expect(Airops::OpenAI::Error.new).to be_a(Airops::Ruby::OpenAI::Error)
      end
    end

    describe "::Airops::Ruby::OpenAI::ConfigurationError" do
      it "is mapped to ::Airops::OpenAI::ConfigurationError" do
        expect(Airops::Ruby::OpenAI::ConfigurationError).to eq(Airops::OpenAI::ConfigurationError)
        expect(Airops::Ruby::OpenAI::ConfigurationError.new).to be_a(Airops::OpenAI::ConfigurationError)
        expect(Airops::OpenAI::ConfigurationError.new).to be_a(Airops::Ruby::OpenAI::ConfigurationError)
      end
    end

    describe "::Airops::Ruby::OpenAI::Configuration" do
      it "is mapped to ::Airops::OpenAI::Configuration" do
        expect(Airops::Ruby::OpenAI::Configuration).to eq(Airops::OpenAI::Configuration)
        expect(Airops::Ruby::OpenAI::Configuration.new).to be_a(Airops::OpenAI::Configuration)
        expect(Airops::OpenAI::Configuration.new).to be_a(Airops::Ruby::OpenAI::Configuration)
      end
    end
  end
end
