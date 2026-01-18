# frozen_string_literal: true

require "rails"
require "view_component"
require "faraday"
require "faraday/retry"
require "dry-schema"
require "turbo-rails"

require_relative "rails_generative_ui/version"
require_relative "rails_generative_ui/configuration"
require_relative "rails_generative_ui/railtie"
require_relative "rails_generative_ui/engine"

# Core components
require_relative "rails_generative_ui/tools/tool"
require_relative "rails_generative_ui/tools/tool_registry"
require_relative "rails_generative_ui/client/ollama_client"
require_relative "rails_generative_ui/client/response"
require_relative "rails_generative_ui/client/tool_call"
require_relative "rails_generative_ui/messages/message_handler"
require_relative "rails_generative_ui/messages/ui_message"
require_relative "rails_generative_ui/messages/message_part"
require_relative "rails_generative_ui/messages/text_part"
require_relative "rails_generative_ui/messages/component_part"
require_relative "rails_generative_ui/messages/conversation"
require_relative "rails_generative_ui/rendering/component_renderer"
require_relative "rails_generative_ui/rendering/streaming_handler"
require_relative "rails_generative_ui/helpers/controller_helpers"
require_relative "rails_generative_ui/helpers/view_helpers"

module RailsGenerativeUi
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class ToolError < Error; end
  class ClientError < Error; end
  class RenderError < Error; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end

    def tool_registry
      @tool_registry ||= Tools::ToolRegistry.new
    end

    def register_tool(tool_class)
      tool_registry.register(tool_class)
    end

    def ollama_client
      @ollama_client ||= Client::OllamaClient.new(configuration)
    end
  end
end
