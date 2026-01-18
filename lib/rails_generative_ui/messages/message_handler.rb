# frozen_string_literal: true

module RailsGenerativeUi
  module Messages
    class MessageHandler
      attr_reader :ollama_client, :tool_registry, :component_renderer

      def initialize(
        ollama_client: RailsGenerativeUi.ollama_client,
        tool_registry: RailsGenerativeUi.tool_registry,
        component_renderer: Rendering::ComponentRenderer.new
      )
        @ollama_client = ollama_client
        @tool_registry = tool_registry
        @component_renderer = component_renderer
      end

      def process(message, conversation, tool_names: [])
        # Add user message to conversation
        user_message = UIMessage.new(role: "user", parts: [TextPart.new(content: message)])
        conversation.add_message(user_message)

        # Get tools for this request
        tools = resolve_tools(tool_names)

        # Call Ollama
        response = ollama_client.chat(
          conversation.to_ollama_messages,
          tools: tools.map(&:to_ollama_tool)
        )

        # Process response
        build_assistant_message(response)
      end

      def process_streaming(message, conversation, tool_names: [], &block)
        # Add user message to conversation
        user_message = UIMessage.new(role: "user", parts: [TextPart.new(content: message)])
        conversation.add_message(user_message)

        # Get tools for this request
        tools = resolve_tools(tool_names)

        # Stream response
        text_buffer = ""
        tool_calls_buffer = []

        ollama_client.stream_chat(
          conversation.to_ollama_messages,
          tools: tools.map(&:to_ollama_tool)
        ) do |chunk|
          if chunk["message"]
            content = chunk["message"]["content"]
            if content
              text_buffer += content
              block.call(type: :text, content: content) if block_given?
            end

            if chunk["message"]["tool_calls"]
              tool_calls_buffer.concat(chunk["message"]["tool_calls"])
            end
          end

          if chunk["done"]
            # Execute tools and yield components
            if tool_calls_buffer.any?
              tool_results = execute_tool_calls(tool_calls_buffer)
              tool_results.each do |result|
                block.call(type: :component, **result) if block_given?
              end
            end
          end
        end
      end

      private

      def resolve_tools(tool_names)
        return [] if tool_names.empty?

        tool_names.map do |name|
          tool_class = tool_registry.find(name.to_s)
          raise ToolError, "Tool not found: #{name}" unless tool_class

          tool_class.new
        end
      end

      def build_assistant_message(response)
        parts = []

        # Add text content if present
        parts << TextPart.new(content: response.content) if response.content

        # Execute tools and add component parts
        if response.has_tool_calls?
          tool_results = execute_tool_calls(response.tool_calls)
          tool_results.each do |result|
            parts << ComponentPart.new(
              tool_name: result[:tool_name],
              state: result[:state],
              output: result[:output],
              error: result[:error]
            )
          end
        end

        UIMessage.new(role: "assistant", parts: parts)
      end

      def execute_tool_calls(tool_calls)
        tool_calls.map do |tc|
          tool_class = tool_registry.find(tc.name || tc["function"]["name"])
          unless tool_class
            next {
              tool_name: tc.name || tc["function"]["name"],
              state: "output-error",
              error: "Tool not found"
            }
          end

          begin
            arguments = tc.is_a?(Hash) ? tc["function"]["arguments"] : tc.arguments
            tool = tool_class.new(arguments)
            output = tool.execute

            {
              tool_name: tool_class.tool_name,
              state: "output-available",
              output: output
            }
          rescue StandardError => e
            {
              tool_name: tool_class.tool_name,
              state: "output-error",
              error: e.message
            }
          end
        end.compact
      end
    end
  end
end
