# Rails Generative UI Gem - Architecture Design

## Gem Name
`rails-generative-ui`

## Overview

The rails-generative-ui gem integrates generative UI capabilities into Ruby on Rails applications, allowing developers to create dynamic, AI-powered user interfaces that go beyond traditional chatbox interactions. The gem leverages Ollama for language model integration and Rails ViewComponents for component rendering.

## Core Components

### 1. Configuration System

**Purpose**: Manage Ollama connection settings and gem behavior

**Implementation**:
- `RailsGenerativeUi.configure` block in initializer
- Support for local and cloud Ollama instances
- Configurable default models, streaming preferences, and timeouts
- Environment-specific configuration support

**Configuration Options**:
- `ollama_base_url` - Base URL for Ollama API (default: http://localhost:11434)
- `default_model` - Default model to use (default: gemma3)
- `streaming_enabled` - Enable streaming responses (default: true)
- `timeout` - API request timeout in seconds (default: 30)
- `api_key` - Optional API key for cloud Ollama

### 2. Tool Registry

**Purpose**: Define and manage tools that the LLM can invoke to generate UI components

**Implementation**:
- Base `RailsGenerativeUi::Tool` class
- Tool registration system
- Input schema validation using dry-schema or similar
- Automatic tool discovery from `app/generative_ui/tools/`

**Tool Structure**:
```ruby
class WeatherTool < RailsGenerativeUi::Tool
  description "Display weather information for a location"
  
  input_schema do
    required(:location).filled(:string)
  end
  
  component WeatherComponent
  
  def execute(location:)
    # Fetch weather data
    {
      temperature: 75,
      condition: "Sunny",
      location: location
    }
  end
end
```

### 3. Component Renderer

**Purpose**: Map tool outputs to ViewComponents and render them

**Implementation**:
- Integration with ViewComponents
- Automatic component instantiation with tool output data
- Support for partial rendering as fallback
- Component caching for performance

**Component Mapping**:
- Tools specify their corresponding ViewComponent
- Component receives tool output as initialization parameters
- Components can be previewed using ViewComponent previews

### 4. Ollama Client

**Purpose**: Handle communication with Ollama API

**Implementation**:
- HTTP client using Faraday
- Support for both streaming and non-streaming requests
- Automatic retry logic with exponential backoff
- Request/response logging for debugging

**API Methods**:
- `generate(prompt, options)` - Generate a response
- `chat(messages, options)` - Chat completion with history
- `stream_chat(messages, options, &block)` - Streaming chat
- `list_models` - List available models

### 5. Message Handler

**Purpose**: Process messages and coordinate tool invocations

**Implementation**:
- Parse LLM responses for tool calls
- Execute tools and collect results
- Build UI message objects with text and component parts
- Handle errors gracefully

**Message Structure**:
```ruby
{
  id: "msg_123",
  role: "assistant",
  parts: [
    { type: "text", content: "Here's the weather:" },
    { type: "component", tool: "weather", state: "output-available", output: {...} }
  ]
}
```

### 6. Streaming Handler

**Purpose**: Enable progressive rendering of UI components

**Implementation**:
- Integration with Rails Turbo Streams
- Server-sent events (SSE) support
- Progressive component rendering
- Graceful degradation for non-streaming clients

**Streaming Flow**:
1. Client initiates request with streaming enabled
2. Server streams text tokens as they arrive
3. When tool is invoked, server streams loading state
4. After tool execution, server streams component HTML
5. Client receives Turbo Stream updates and renders progressively

### 7. Controller Helpers

**Purpose**: Simplify integration into Rails controllers

**Implementation**:
- `generative_ui_chat` helper method
- Automatic message history management
- Session-based conversation tracking
- Response format handling (HTML, Turbo Stream, JSON)

**Usage Example**:
```ruby
class ChatController < ApplicationController
  include RailsGenerativeUi::ControllerHelpers
  
  def create
    respond_to do |format|
      format.turbo_stream do
        generative_ui_chat(
          message: params[:message],
          tools: [WeatherTool, ProductSearchTool]
        )
      end
    end
  end
end
```

### 8. View Helpers

**Purpose**: Provide view helpers for rendering generative UI interfaces

**Implementation**:
- `generative_ui_container` - Render multi-panel layout
- `generative_ui_messages` - Render message history
- `generative_ui_input` - Render input form with Turbo
- `generative_ui_panel` - Render individual panels

### 9. Layout System

**Purpose**: Provide pre-built layouts for multi-panel interfaces

**Implementation**:
- Default multi-panel layout template
- Customizable panel configurations
- Responsive design with mobile support
- Accessibility features (ARIA labels, keyboard navigation)

**Layout Structure**:
- Main conversation panel (center)
- Context panel (left, collapsible)
- Preview panel (right, collapsible)
- Action bar (bottom)
- Input area (bottom)

## Data Flow

### Standard Request Flow

1. User submits message through input form
2. Controller receives message and calls `generative_ui_chat`
3. Message handler adds message to conversation history
4. Ollama client sends request with message and available tools
5. LLM processes request and may invoke tools
6. Tools execute and return structured data
7. Component renderer maps tool outputs to ViewComponents
8. Response is rendered as Turbo Stream updates
9. Client receives and displays components

### Streaming Request Flow

1. User submits message through input form
2. Controller initiates streaming response
3. Ollama client opens streaming connection
4. As tokens arrive, they're streamed to client via SSE
5. When tool invocation detected, loading state is streamed
6. Tool executes in background
7. Component HTML is streamed when tool completes
8. Client progressively updates UI with each stream chunk

## File Structure

```
rails-generative-ui/
├── lib/
│   ├── rails_generative_ui.rb                 # Main entry point
│   ├── rails_generative_ui/
│   │   ├── version.rb                         # Version constant
│   │   ├── configuration.rb                   # Configuration class
│   │   ├── railtie.rb                         # Rails integration
│   │   ├── engine.rb                          # Rails engine
│   │   ├── tool.rb                            # Base tool class
│   │   ├── tool_registry.rb                   # Tool registration
│   │   ├── ollama_client.rb                   # Ollama API client
│   │   ├── message_handler.rb                 # Message processing
│   │   ├── streaming_handler.rb               # Streaming support
│   │   ├── component_renderer.rb              # Component rendering
│   │   ├── controller_helpers.rb              # Controller helpers
│   │   ├── view_helpers.rb                    # View helpers
│   │   └── generators/                        # Rails generators
│   │       ├── install_generator.rb           # Install generator
│   │       ├── tool_generator.rb              # Tool generator
│   │       ├── component_generator.rb         # Component generator
│   │       └── layout_generator.rb            # Layout generator
│   └── generators/
│       └── rails_generative_ui/
│           └── templates/                     # Generator templates
├── app/
│   ├── assets/
│   │   ├── stylesheets/
│   │   │   └── rails_generative_ui.css       # Default styles
│   │   └── javascripts/
│   │       └── rails_generative_ui.js        # Client-side JS
│   ├── components/
│   │   └── rails_generative_ui/
│   │       ├── container_component.rb        # Main container
│   │       ├── message_component.rb          # Message display
│   │       ├── input_component.rb            # Input form
│   │       └── loading_component.rb          # Loading indicator
│   └── views/
│       └── rails_generative_ui/
│           └── layouts/
│               └── default.html.erb          # Default layout
├── spec/                                      # RSpec tests
│   ├── spec_helper.rb
│   ├── rails_helper.rb
│   ├── lib/
│   │   └── rails_generative_ui/
│   │       ├── tool_spec.rb
│   │       ├── ollama_client_spec.rb
│   │       └── message_handler_spec.rb
│   └── integration/
│       └── generative_ui_flow_spec.rb
├── features/                                  # Cucumber features
│   ├── support/
│   │   └── env.rb
│   └── generative_ui.feature
├── bin/
│   └── rails-generative-ui                   # CLI tool
├── Gemfile
├── rails-generative-ui.gemspec
├── Rakefile
├── README.md
└── LICENSE
```

## Dependencies

### Runtime Dependencies
- `rails` >= 7.0
- `view_component` >= 3.0
- `faraday` >= 2.0 (HTTP client)
- `faraday-retry` (retry logic)
- `dry-schema` >= 1.13 (input validation)
- `turbo-rails` >= 1.0 (streaming support)

### Development Dependencies
- `rspec-rails` >= 6.0
- `cucumber-rails` >= 2.0
- `factory_bot_rails` >= 6.0
- `webmock` >= 3.0 (HTTP mocking)
- `simplecov` (code coverage)
- `rubocop` (linting)
- `rubocop-rails` (Rails-specific linting)
- `rubocop-rspec` (RSpec-specific linting)

## Testing Strategy

### RSpec Unit Tests
- Test each class in isolation
- Mock external dependencies (Ollama API)
- Test error handling and edge cases
- Achieve >90% code coverage

### RSpec Integration Tests
- Test complete request/response flow
- Use WebMock to stub Ollama API responses
- Test Turbo Stream rendering
- Test component rendering with real ViewComponents

### Cucumber Acceptance Tests
- Test user-facing scenarios
- Use Capybara for browser automation
- Test streaming behavior
- Test multi-panel layouts

### Example Cucumber Scenario
```gherkin
Feature: Generative UI Chat
  As a user
  I want to interact with an AI assistant
  And see rich UI components in responses

  Scenario: User requests weather information
    Given I am on the chat page
    When I type "What's the weather in San Francisco?"
    And I press "Send"
    Then I should see a loading indicator
    And I should see a weather card with temperature and conditions
    And the weather card should show "San Francisco"
```

## Security Considerations

### Tool Authorization
- Integrate with Rails authorization frameworks (Pundit, CanCanCan)
- Each tool can define authorization requirements
- Check permissions before tool execution
- Log unauthorized access attempts

### Output Sanitization
- Sanitize all text content by default
- Use Rails sanitization helpers
- Allow safe HTML in component templates
- Prevent XSS attacks

### Rate Limiting
- Use Rack::Attack or similar for rate limiting
- Configurable limits per user/session
- Separate limits for streaming vs non-streaming
- Graceful degradation when limits exceeded

### API Key Security
- Store API keys in Rails credentials
- Never expose keys in client-side code
- Support environment variable configuration
- Rotate keys regularly

## Performance Considerations

### Caching
- Cache tool outputs when appropriate
- Cache rendered components
- Use Rails fragment caching
- Configurable cache expiration

### Background Processing
- Support background tool execution for long-running tasks
- Integration with Sidekiq or similar
- Progress updates via ActionCable
- Timeout handling

### Database Optimization
- Store conversation history efficiently
- Index frequently queried fields
- Implement pagination for long conversations
- Archive old conversations

## Accessibility

### WCAG Compliance
- Semantic HTML in all components
- ARIA labels for interactive elements
- Keyboard navigation support
- Screen reader compatibility

### Progressive Enhancement
- Work without JavaScript (basic functionality)
- Graceful degradation for older browsers
- Mobile-responsive design
- Touch-friendly interactions

## Documentation Requirements

### README
- Quick start guide
- Installation instructions
- Basic usage examples
- Configuration options
- Links to detailed docs

### Wiki/Guides
- Tool creation guide
- Component mapping guide
- Streaming implementation guide
- Layout customization guide
- Testing guide
- Deployment guide

### API Documentation
- YARD documentation for all public methods
- Example code for common use cases
- Configuration reference
- Troubleshooting guide

### Example Application
- Complete working Rails app
- Multiple tool examples
- Custom layout example
- Testing examples
- Deployment configuration

## Versioning and Release Strategy

### Semantic Versioning
- Follow semver (MAJOR.MINOR.PATCH)
- Document breaking changes clearly
- Provide migration guides for major versions
- Maintain changelog

### Release Process
1. Update version number
2. Update CHANGELOG.md
3. Run full test suite
4. Build gem
5. Push to RubyGems
6. Tag release in Git
7. Update documentation
8. Announce release

## Future Enhancements

### Phase 2 Features
- Multi-modal support (images, audio)
- Voice input/output
- Real-time collaboration
- Custom model fine-tuning
- Analytics and usage tracking

### Phase 3 Features
- Visual UI builder
- Component marketplace
- Advanced caching strategies
- Distributed tool execution
- Multi-language support

## Conclusion

This architecture provides a solid foundation for building generative UI capabilities into Rails applications. By following Rails conventions and integrating with existing Rails technologies, the gem will feel natural to Rails developers while providing powerful new capabilities for creating AI-native user experiences.
