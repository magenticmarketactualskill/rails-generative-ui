Feature: Generative UI Chat
  As a user
  I want to interact with an AI assistant
  And see rich UI components in responses

  Background:
    Given Ollama is running and available
    And the weather tool is registered

  Scenario: User requests weather information
    Given I am on the chat page
    When I type "What's the weather in San Francisco?"
    And I press "Send"
    Then I should see a loading indicator
    And I should see a weather component
    And the weather component should show "San Francisco"

  Scenario: User receives text-only response
    Given I am on the chat page
    When I type "Hello, how are you?"
    And I press "Send"
    Then I should see a text response from the assistant
    And I should not see any UI components

  Scenario: Tool execution fails gracefully
    Given I am on the chat page
    And the weather tool will fail
    When I type "What's the weather in Invalid City?"
    And I press "Send"
    Then I should see an error message
    And the error message should mention "weather"

  Scenario: Streaming response with components
    Given I am on the chat page
    And streaming is enabled
    When I type "Show me the weather in New York"
    And I press "Send"
    Then I should see text appearing progressively
    And I should see a weather component appear after the text
