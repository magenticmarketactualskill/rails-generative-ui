# frozen_string_literal: true

module RailsGenerativeUi
  module Tools
    class ToolRegistry
      def initialize
        @tools = {}
      end

      def register(tool_class)
        raise ToolError, "Tool must inherit from RailsGenerativeUi::Tools::Tool" unless tool_class < Tool

        tool_name = tool_class.tool_name
        @tools[tool_name] = tool_class
        Rails.logger.info "Registered tool: #{tool_name}" if defined?(Rails)
      end

      def unregister(tool_name)
        @tools.delete(tool_name.to_s)
      end

      def find(tool_name)
        @tools[tool_name.to_s]
      end

      def all
        @tools.values
      end

      def tool_names
        @tools.keys
      end

      def to_ollama_tools
        all.map { |tool_class| tool_class.new.to_ollama_tool }
      end

      def clear!
        @tools.clear
      end
    end
  end
end
