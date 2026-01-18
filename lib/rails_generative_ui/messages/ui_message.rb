# frozen_string_literal: true

module RailsGenerativeUi
  module Messages
    class UIMessage
      attr_reader :id, :role, :parts, :created_at

      def initialize(role:, parts: [], id: nil, created_at: nil)
        @id = id || SecureRandom.uuid
        @role = role
        @parts = parts
        @created_at = created_at || Time.current
      end

      def text_content
        parts.select { |p| p.is_a?(TextPart) }.map(&:content).join(" ")
      end

      def component_parts
        parts.select { |p| p.is_a?(ComponentPart) }
      end

      def to_h
        {
          id: id,
          role: role,
          parts: parts.map(&:to_h),
          created_at: created_at
        }
      end

      def to_ollama_message
        {
          role: role,
          content: text_content
        }
      end
    end
  end
end
