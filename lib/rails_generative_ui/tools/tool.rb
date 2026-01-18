# frozen_string_literal: true

module RailsGenerativeUi
  module Tools
    class Tool
      class << self
        attr_accessor :tool_description, :tool_component_class

        def description(desc = nil)
          @tool_description = desc if desc
          @tool_description
        end

        def component(component_class = nil)
          @tool_component_class = component_class if component_class
          @tool_component_class
        end

        def input_schema(&block)
          @input_schema_block = block if block_given?
          @input_schema ||= Dry::Schema.Params(&@input_schema_block) if @input_schema_block
        end

        def tool_name
          name.demodulize.underscore.gsub(/_tool$/, "")
        end

        def inherited(subclass)
          super
          RailsGenerativeUi.register_tool(subclass)
        end
      end

      def initialize(params = {})
        @params = params
        validate_input!
      end

      def execute
        raise NotImplementedError, "#{self.class.name} must implement #execute"
      end

      def to_ollama_tool
        {
          type: "function",
          function: {
            name: self.class.tool_name,
            description: self.class.description,
            parameters: schema_to_json_schema
          }
        }
      end

      private

      def validate_input!
        return unless self.class.input_schema

        result = self.class.input_schema.call(@params)
        raise ToolError, "Invalid input: #{result.errors.to_h}" if result.failure?

        @params = result.to_h
      end

      def schema_to_json_schema
        # Convert Dry::Schema to JSON Schema format
        # This is a simplified version - a full implementation would be more comprehensive
        {
          type: "object",
          properties: @params.transform_values { |v| { type: json_type_for(v) } },
          required: @params.keys.map(&:to_s)
        }
      end

      def json_type_for(value)
        case value
        when String then "string"
        when Integer then "integer"
        when Float then "number"
        when TrueClass, FalseClass then "boolean"
        when Array then "array"
        when Hash then "object"
        else "string"
        end
      end
    end
  end
end
