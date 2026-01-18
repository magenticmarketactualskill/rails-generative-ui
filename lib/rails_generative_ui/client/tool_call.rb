# frozen_string_literal: true

module RailsGenerativeUi
  module Client
    class ToolCall
      attr_reader :name, :arguments, :id

      def initialize(name:, arguments:, id: nil)
        @name = name
        @arguments = arguments.is_a?(Hash) ? arguments : JSON.parse(arguments)
        @id = id || SecureRandom.uuid
      end

      def to_h
        {
          id: id,
          name: name,
          arguments: arguments
        }
      end
    end
  end
end
