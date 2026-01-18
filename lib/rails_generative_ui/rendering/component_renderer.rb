# frozen_string_literal: true

module RailsGenerativeUi
  module Rendering
    class ComponentRenderer
      def render_component(tool_name, output)
        component_class = find_component_class(tool_name)
        return render_fallback(tool_name, output) unless component_class

        begin
          component = instantiate_component(component_class, output)
          component.render_in(view_context)
        rescue StandardError => e
          Rails.logger.error "Failed to render component #{component_class.name}: #{e.message}" if defined?(Rails)
          render_error(tool_name, e.message)
        end
      end

      def render_loading(tool_name)
        loading_component = RailsGenerativeUi::LoadingComponent.new(tool_name: tool_name)
        loading_component.render_in(view_context)
      rescue StandardError
        %(<div class="rails-generative-ui-loading">Loading #{tool_name}...</div>)
      end

      def render_error(tool_name, error)
        %(<div class="rails-generative-ui-error">
          <strong>Error in #{tool_name}:</strong> #{ERB::Util.html_escape(error)}
        </div>)
      end

      private

      def find_component_class(tool_name)
        tool_class = RailsGenerativeUi.tool_registry.find(tool_name)
        return nil unless tool_class

        tool_class.component
      end

      def instantiate_component(component_class, output)
        if output.is_a?(Hash)
          component_class.new(**output.symbolize_keys)
        else
          component_class.new(data: output)
        end
      end

      def render_fallback(tool_name, output)
        %(<div class="rails-generative-ui-fallback">
          <h4>#{tool_name}</h4>
          <pre>#{ERB::Util.html_escape(JSON.pretty_generate(output))}</pre>
        </div>)
      end

      def view_context
        @view_context ||= ApplicationController.new.view_context
      end
    end
  end
end
