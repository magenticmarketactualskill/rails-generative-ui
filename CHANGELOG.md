# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-17

### Added
- Initial release of rails-generative-ui gem
- Tool-based architecture for defining UI components
- Ollama client integration with support for local and cloud instances
- Streaming support via Turbo Streams
- ViewComponent integration for rendering UI components
- Message handling and conversation management
- Controller and view helpers for easy integration
- Multi-panel layout support
- Comprehensive RSpec test suite
- Cucumber acceptance tests
- Configuration system with environment variable support
- Input validation using dry-schema
- Error handling and graceful degradation
- Documentation and examples

### Features
- Define tools that map to ViewComponents
- Automatic tool discovery from app/generative_ui/tools
- Progressive rendering of UI components
- Session-based conversation tracking
- Configurable timeouts and retry logic
- Support for both streaming and non-streaming responses
- Component caching for performance
- Fallback rendering for missing components

[0.1.0]: https://github.com/example/rails-generative-ui/releases/tag/v0.1.0
