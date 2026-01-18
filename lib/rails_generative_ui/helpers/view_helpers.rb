# frozen_string_literal: true

module RailsGenerativeUi
  module Helpers
    module ViewHelpers
      def generative_ui_container(messages: [], layout: :default, **options)
        render RailsGenerativeUi::ContainerComponent.new(
          messages: messages,
          layout: layout,
          **options
        )
      end

      def generative_ui_messages(messages)
        messages.map do |message|
          render RailsGenerativeUi::MessageComponent.new(message: message)
        end.join.html_safe
      end

      def generative_ui_input(url:, **options)
        render RailsGenerativeUi::InputComponent.new(
          url: url,
          **options
        )
      end

      def generative_ui_panel(type, content = nil, **options, &block)
        content = capture(&block) if block_given?
        
        tag.div(class: "rails-generative-ui-panel rails-generative-ui-panel--#{type}", **options) do
          content
        end
      end
    end
  end
end
