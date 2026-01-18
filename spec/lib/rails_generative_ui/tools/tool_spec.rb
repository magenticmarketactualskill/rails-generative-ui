# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsGenerativeUi::Tools::Tool do
  let(:test_tool_class) do
    Class.new(described_class) do
      description "A test tool"
      
      input_schema do
        required(:name).filled(:string)
        optional(:age).filled(:integer)
      end

      def execute
        { result: "Hello, #{@params[:name]}!" }
      end
    end
  end

  before do
    stub_const("TestTool", test_tool_class)
  end

  describe ".description" do
    it "sets and returns the description" do
      expect(TestTool.description).to eq("A test tool")
    end
  end

  describe ".tool_name" do
    it "returns the underscored class name without _tool suffix" do
      expect(TestTool.tool_name).to eq("test")
    end
  end

  describe "#initialize" do
    it "validates input against schema" do
      expect { TestTool.new(name: "John") }.not_to raise_error
    end

    it "raises error for invalid input" do
      expect { TestTool.new(age: 25) }.to raise_error(RailsGenerativeUi::ToolError, /Invalid input/)
    end

    it "accepts optional parameters" do
      tool = TestTool.new(name: "John", age: 25)
      expect(tool.instance_variable_get(:@params)).to include(name: "John", age: 25)
    end
  end

  describe "#execute" do
    it "must be implemented by subclasses" do
      base_tool = described_class.new
      expect { base_tool.execute }.to raise_error(NotImplementedError)
    end

    it "executes the tool logic" do
      tool = TestTool.new(name: "John")
      result = tool.execute
      expect(result).to eq(result: "Hello, John!")
    end
  end

  describe "#to_ollama_tool" do
    it "converts tool to Ollama tool format" do
      tool = TestTool.new(name: "John")
      ollama_tool = tool.to_ollama_tool

      expect(ollama_tool).to include(
        type: "function",
        function: hash_including(
          name: "test",
          description: "A test tool",
          parameters: hash_including(type: "object")
        )
      )
    end
  end
end
