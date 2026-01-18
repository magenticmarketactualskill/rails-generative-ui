# frozen_string_literal: true

module RailsGenerativeUi
  class Configuration
    attr_accessor :ollama_base_url, :default_model, :streaming_enabled,
                  :timeout, :api_key, :max_retries, :retry_delay

    def initialize
      @ollama_base_url = ENV.fetch("OLLAMA_BASE_URL", "http://localhost:11434")
      @default_model = ENV.fetch("OLLAMA_DEFAULT_MODEL", "gemma3")
      @streaming_enabled = true
      @timeout = 30
      @api_key = ENV["OLLAMA_API_KEY"]
      @max_retries = 3
      @retry_delay = 1
    end

    def validate!
      raise ConfigurationError, "ollama_base_url cannot be blank" if ollama_base_url.to_s.strip.empty?
      raise ConfigurationError, "default_model cannot be blank" if default_model.to_s.strip.empty?
      raise ConfigurationError, "timeout must be positive" if timeout.to_i <= 0
      raise ConfigurationError, "max_retries must be non-negative" if max_retries.to_i < 0

      true
    end

    def api_url
      "#{ollama_base_url}/api"
    end
  end
end
