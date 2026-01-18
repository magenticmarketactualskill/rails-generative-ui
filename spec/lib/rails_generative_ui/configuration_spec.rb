# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsGenerativeUi::Configuration do
  subject(:config) { described_class.new }

  describe "#initialize" do
    it "sets default values" do
      expect(config.ollama_base_url).to eq("http://localhost:11434")
      expect(config.default_model).to eq("gemma3")
      expect(config.streaming_enabled).to be true
      expect(config.timeout).to eq(30)
      expect(config.max_retries).to eq(3)
      expect(config.retry_delay).to eq(1)
    end

    context "with environment variables" do
      before do
        ENV["OLLAMA_BASE_URL"] = "https://custom.ollama.com"
        ENV["OLLAMA_DEFAULT_MODEL"] = "llama3"
      end

      after do
        ENV.delete("OLLAMA_BASE_URL")
        ENV.delete("OLLAMA_DEFAULT_MODEL")
      end

      it "uses environment variables" do
        config = described_class.new
        expect(config.ollama_base_url).to eq("https://custom.ollama.com")
        expect(config.default_model).to eq("llama3")
      end
    end
  end

  describe "#validate!" do
    it "returns true for valid configuration" do
      expect(config.validate!).to be true
    end

    it "raises error for blank ollama_base_url" do
      config.ollama_base_url = ""
      expect { config.validate! }.to raise_error(RailsGenerativeUi::ConfigurationError, /ollama_base_url/)
    end

    it "raises error for blank default_model" do
      config.default_model = ""
      expect { config.validate! }.to raise_error(RailsGenerativeUi::ConfigurationError, /default_model/)
    end

    it "raises error for non-positive timeout" do
      config.timeout = 0
      expect { config.validate! }.to raise_error(RailsGenerativeUi::ConfigurationError, /timeout/)
    end

    it "raises error for negative max_retries" do
      config.max_retries = -1
      expect { config.validate! }.to raise_error(RailsGenerativeUi::ConfigurationError, /max_retries/)
    end
  end

  describe "#api_url" do
    it "returns the API URL" do
      expect(config.api_url).to eq("http://localhost:11434/api")
    end

    it "handles custom base URL" do
      config.ollama_base_url = "https://custom.ollama.com"
      expect(config.api_url).to eq("https://custom.ollama.com/api")
    end
  end
end
