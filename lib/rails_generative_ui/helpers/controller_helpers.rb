# frozen_string_literal: true

module RailsGenerativeUi
  module Helpers
    module ControllerHelpers
      extend ActiveSupport::Concern

      included do
        helper_method :current_generative_ui_conversation if respond_to?(:helper_method)
      end

      def generative_ui_chat(message:, tools: [], model: nil)
        conversation = current_generative_ui_conversation
        handler = Messages::MessageHandler.new

        assistant_message = handler.process(
          message,
          conversation,
          tool_names: tools.map { |t| t.is_a?(Class) ? t.tool_name : t }
        )

        conversation.add_message(assistant_message)
        save_generative_ui_conversation(conversation)

        assistant_message
      end

      def generative_ui_stream(message:, tools: [], model: nil, &block)
        conversation = current_generative_ui_conversation
        handler = Messages::MessageHandler.new
        streaming_handler = Rendering::StreamingHandler.new

        response.headers["Content-Type"] = "text/vnd.turbo-stream.html"
        response.headers["X-Accel-Buffering"] = "no"

        self.response_body = Enumerator.new do |yielder|
          handler.process_streaming(
            message,
            conversation,
            tool_names: tools.map { |t| t.is_a?(Class) ? t.tool_name : t }
          ) do |chunk|
            case chunk[:type]
            when :text
              stream_chunk = streaming_handler.stream_text(chunk[:content])
              yielder << stream_chunk
            when :component
              if chunk[:state] == "output-available"
                component_html = Rendering::ComponentRenderer.new.render_component(
                  chunk[:tool_name],
                  chunk[:output]
                )
                stream_chunk = streaming_handler.stream_component(component_html)
                yielder << stream_chunk
              elsif chunk[:state] == "output-error"
                stream_chunk = streaming_handler.stream_error(chunk[:error])
                yielder << stream_chunk
              end
            end

            block.call(chunk) if block_given?
          end
        end
      end

      def current_generative_ui_conversation
        conversation_data = session[:generative_ui_conversation]
        if conversation_data
          Messages::Conversation.from_hash(conversation_data.deep_symbolize_keys)
        else
          Messages::Conversation.new
        end
      end

      def save_generative_ui_conversation(conversation)
        session[:generative_ui_conversation] = conversation.to_h
      end

      def reset_generative_ui_conversation!
        session.delete(:generative_ui_conversation)
      end
    end
  end
end
