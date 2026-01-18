# frozen_string_literal: true

module RailsGenerativeUi
  module Messages
    class TextPart < MessagePart
      attr_reader :content

      def initialize(content:)
        super(type: "text")
        @content = content
      end

      def render
        content
      end

      def to_h
        super.merge(content: content)
      end
    end
  end
end
