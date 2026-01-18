# Generative UI Research Notes

## Source
Article: "Working in a chatbox was a mistake, and Generative UI is the antidote" by Marco van Hurne
URL: https://pub.towardsai.net/working-in-a-chatbox-was-a-mistake-and-generative-ui-is-the-antidote-1890bac7cfb5

## Key Concepts

### The Problem with Chatboxes
- Traditional AI interfaces trap users in a single text input field (the "cardboard box")
- Chatboxes force users to type everything, losing the rich UI/UX of traditional applications
- Enterprise applications (ChatGPT Apps, Microsoft Copilot) are consolidating multiple tools into a single chat interface
- This creates a "prompt-shaped" interaction model where users must beg the AI rather than directly control the interface
- The minimalist chat interface was fine for toys but inadequate for professional work

### What is Generative UI?
Generative UI is the antidote to chatbox-centric interfaces. Key principles:

1. **Rich Interactive Components**: Instead of text-only responses, generate actual UI elements:
   - Buttons, sliders, dropdowns, toggles
   - Side panels with selectors and filters
   - Product cards, grids, and visual layouts
   - File management with drag-and-drop
   - Live preview panels

2. **Multi-layered Dashboard Design**: 
   - Cockpit-style interface with multiple panels
   - Left panel for context
   - Right panel for previews
   - Bottom bar for command history
   - Floating action bars
   - Chat input becomes ONE of many entry points, not the only one

3. **Physical Interaction**: 
   - Make interactions visual, clickable, and responsive
   - Allow drag-and-drop operations
   - Enable highlighting, annotation, and direct manipulation
   - Provide diff compare and version rollback for content creation

4. **Context-Aware UI Generation**:
   - AI generates appropriate UI components based on the task
   - Shopping: size selectors, style toggles, budget sliders
   - File management: grid views with preview snippets
   - Content creation: live output preview with editing tools

### Technical Implementation Considerations

The article emphasizes:
- Moving beyond "prompt-only" interfaces
- Generating rich, interactive UI components dynamically
- Providing multiple interaction modalities (not just text)
- Creating dashboard-like experiences with multiple panels
- Enabling direct manipulation of UI elements
- Maintaining visual richness while leveraging AI capabilities

### For Rails Integration

Key takeaways for rails-generative-ui gem:
1. Need to generate ViewComponents or Partials dynamically based on AI responses
2. Should support rich UI elements (buttons, forms, sliders, etc.)
3. Must integrate with LLM (Ollama) to determine what UI to generate
4. Should provide a framework for multi-panel layouts
5. Enable developers to define UI component templates that AI can select and populate
6. Support both streaming responses and rich UI rendering
7. Allow for progressive enhancement - start with chat, add rich UI as needed


## Ollama Overview

### What is Ollama?
Ollama is a platform for running large language models locally or via cloud. It provides an easy way to get up and running with models like GPT-OSS, Gemma 3, DeepSeek-R1, Qwen3, and many others.

### Key Features
- Local model hosting (runs on macOS, Windows, Linux)
- Cloud models available for larger/better performance
- Support for various model capabilities:
  - Tool calling
  - Vision models
  - Embeddings
  - Thinking/reasoning models
  - Structured outputs
  - Web search integration

### API Information
- **Base URL (local)**: `http://localhost:11434/api`
- **Base URL (cloud)**: `https://ollama.com/api`
- API is automatically available once Ollama is running
- Not strictly versioned but stable and backwards compatible
- Official libraries available for Python and JavaScript
- Community libraries available for 20+ languages

### API Endpoints
- POST `/api/generate` - Generate a response
- POST `/api/chat` - Generate a chat message
- POST `/api/embeddings` - Generate embeddings
- GET `/api/tags` - List models
- GET `/api/ps` - List running models
- POST `/api/show` - Show model details
- POST `/api/create` - Create a model

### Example Request
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "gemma3",
  "prompt": "Why is the sky blue?"
}'
```

### Integration Considerations for Rails Gem
1. Gem should support both local and cloud Ollama instances
2. Need to provide configuration for base URL
3. Should wrap Ollama's chat/generate endpoints
4. Can leverage tool calling for UI component selection
5. Support streaming responses for real-time UI generation
6. Use structured outputs to ensure consistent UI component data
7. Consider using Ruby HTTP client (Faraday or HTTParty) for API calls
