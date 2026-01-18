# frozen_string_literal: true

module RailsGenerativeUi
  module Client
    class OllamaClient
      attr_reader :config

      def initialize(config = RailsGenerativeUi.configuration)
        @config = config
        @config.validate!
        @http_client = build_http_client
      end

      def generate(prompt, options = {})
        payload = {
          model: options[:model] || config.default_model,
          prompt: prompt,
          stream: false
        }.merge(options.slice(:temperature, :top_p, :top_k))

        response = @http_client.post("generate", payload)
        parse_response(response)
      end

      def chat(messages, tools: [], options: {})
        payload = {
          model: options[:model] || config.default_model,
          messages: format_messages(messages),
          stream: false
        }

        payload[:tools] = tools if tools.any?
        payload.merge!(options.slice(:temperature, :top_p, :top_k))

        response = @http_client.post("chat", payload)
        parse_response(response)
      end

      def stream_chat(messages, tools: [], options: {}, &block)
        payload = {
          model: options[:model] || config.default_model,
          messages: format_messages(messages),
          stream: true
        }

        payload[:tools] = tools if tools.any?
        payload.merge!(options.slice(:temperature, :top_p, :top_k))

        @http_client.post("chat", payload) do |req|
          req.options.on_data = proc do |chunk, _size|
            next if chunk.strip.empty?

            begin
              data = JSON.parse(chunk)
              block.call(data) if block_given?
            rescue JSON::ParserError => e
              Rails.logger.error "Failed to parse streaming chunk: #{e.message}" if defined?(Rails)
            end
          end
        end
      end

      def list_models
        response = @http_client.get("tags")
        JSON.parse(response.body)["models"] || []
      rescue StandardError => e
        raise ClientError, "Failed to list models: #{e.message}"
      end

      private

      def build_http_client
        Faraday.new(url: config.api_url) do |conn|
          conn.request :json
          conn.request :retry, max: config.max_retries, interval: config.retry_delay
          conn.response :json, content_type: /\bjson$/
          conn.options.timeout = config.timeout
          conn.headers["Authorization"] = "Bearer #{config.api_key}" if config.api_key
          conn.adapter Faraday.default_adapter
        end
      end

      def format_messages(messages)
        messages.map do |msg|
          case msg
          when Hash
            msg
          when Messages::UIMessage
            { role: msg.role, content: msg.text_content }
          else
            raise ClientError, "Invalid message format: #{msg.class}"
          end
        end
      end

      def parse_response(response)
        raise ClientError, "HTTP #{response.status}: #{response.body}" unless response.success?

        body = response.body
        Response.new(
          content: body["message"]&.dig("content") || body["response"],
          tool_calls: parse_tool_calls(body["message"]),
          model: body["model"],
          done: body["done"]
        )
      rescue StandardError => e
        raise ClientError, "Failed to parse response: #{e.message}"
      end

      def parse_tool_calls(message)
        return [] unless message && message["tool_calls"]

        message["tool_calls"].map do |tc|
          ToolCall.new(
            name: tc["function"]["name"],
            arguments: tc["function"]["arguments"],
            id: tc["id"]
          )
        end
      end
    end
  end
end
