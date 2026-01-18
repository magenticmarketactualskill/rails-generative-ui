# frozen_string_literal: true

module RailsGenerativeUi
  module Messages
    class Conversation
      attr_reader :id, :messages

      def initialize(id: nil, messages: [])
        @id = id || SecureRandom.uuid
        @messages = messages
      end

      def add_message(message)
        @messages << message
      end

      def to_ollama_messages
        messages.map(&:to_ollama_message)
      end

      def to_h
        {
          id: id,
          messages: messages.map(&:to_h)
        }
      end

      def self.from_hash(hash)
        messages = hash[:messages].map do |msg_hash|
          parts = msg_hash[:parts].map do |part_hash|
            case part_hash[:type]
            when "text"
              TextPart.new(content: part_hash[:content])
            when "component"
              ComponentPart.new(
                tool_name: part_hash[:tool_name],
                state: part_hash[:state],
                output: part_hash[:output],
                error: part_hash[:error]
              )
            end
          end.compact

          UIMessage.new(
            id: msg_hash[:id],
            role: msg_hash[:role],
            parts: parts,
            created_at: msg_hash[:created_at]
          )
        end

        new(id: hash[:id], messages: messages)
      end
    end
  end
end
