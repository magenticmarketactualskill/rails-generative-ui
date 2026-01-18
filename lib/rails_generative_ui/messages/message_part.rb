# frozen_string_literal: true

module RailsGenerativeUi
  module Messages
    class MessagePart
      attr_reader :type

      def initialize(type:)
        @type = type
      end

      def render
        raise NotImplementedError, "#{self.class.name} must implement #render"
      end

      def to_h
        { type: type }
      end
    end
  end
end
