# frozen_string_literal: true

module RailsGenerativeUi
  module Messages
    class ComponentPart < MessagePart
      attr_reader :tool_name, :state, :output, :error

      def initialize(tool_name:, state: "input-available", output: nil, error: nil)
        super(type: "component")
        @tool_name = tool_name
        @state = state
        @output = output
        @error = error
      end

      def render
        case state
        when "input-available"
          Rendering::ComponentRenderer.new.render_loading(tool_name)
        when "output-available"
          Rendering::ComponentRenderer.new.render_component(tool_name, output)
        when "output-error"
          Rendering::ComponentRenderer.new.render_error(tool_name, error)
        else
          ""
        end
      end

      def to_h
        super.merge(
          tool_name: tool_name,
          state: state,
          output: output,
          error: error
        ).compact
      end
    end
  end
end
