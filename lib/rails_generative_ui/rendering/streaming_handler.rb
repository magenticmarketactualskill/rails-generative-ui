# frozen_string_literal: true

module RailsGenerativeUi
  module Rendering
    class StreamingHandler
      def stream_text(text, target: "messages")
        turbo_stream_append(target, text)
      end

      def stream_component(component_html, target: "messages")
        turbo_stream_append(target, component_html)
      end

      def stream_loading(tool_name, target: "messages")
        loading_html = ComponentRenderer.new.render_loading(tool_name)
        turbo_stream_append(target, loading_html)
      end

      def stream_error(error, target: "messages")
        error_html = %(<div class="rails-generative-ui-error">#{ERB::Util.html_escape(error)}</div>)
        turbo_stream_append(target, error_html)
      end

      private

      def turbo_stream_append(target, content)
        <<~TURBO
          <turbo-stream action="append" target="#{target}">
            <template>
              #{content}
            </template>
          </turbo-stream>
        TURBO
      end
    end
  end
end
