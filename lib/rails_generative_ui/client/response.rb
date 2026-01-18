# frozen_string_literal: true

module RailsGenerativeUi
  module Client
    class Response
      attr_reader :content, :tool_calls, :model, :done

      def initialize(content:, tool_calls: [], model: nil, done: true)
        @content = content
        @tool_calls = tool_calls
        @model = model
        @done = done
      end

      def has_tool_calls?
        tool_calls.any?
      end

      def text_only?
        !has_tool_calls?
      end
    end
  end
end
