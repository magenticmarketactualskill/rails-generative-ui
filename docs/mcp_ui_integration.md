                                                                                                                                                                                        
  Comparison                                                                                                                                                                            
  ┌────────────┬───────────────────────────────────────────┬─────────────────────────────────────────────────┐                                                                          
  │   Aspect   │        rails-generative-ui (yours)        │               mcp + mcp_ui_server               │                                                                          
  ├────────────┼───────────────────────────────────────────┼─────────────────────────────────────────────────┤                                                                          
  │ Purpose    │ Build generative UI inside your Rails app │ Expose your Rails app to external AI agents     │                                                                          
  ├────────────┼───────────────────────────────────────────┼─────────────────────────────────────────────────┤                                                                          
  │ LLM        │ Ollama (you control)                      │ Any MCP client (Claude, ChatGPT, etc.)          │                                                                          
  ├────────────┼───────────────────────────────────────────┼─────────────────────────────────────────────────┤                                                                          
  │ Rendering  │ ViewComponents + Turbo Streams            │ iframes / external URLs / remote-dom            │                                                                          
  ├────────────┼───────────────────────────────────────────┼─────────────────────────────────────────────────┤                                                                          
  │ UI runs in │ Your Rails app directly                   │ Sandboxed iframe in host (Claude Desktop, etc.) │                                                                          
  ├────────────┼───────────────────────────────────────────┼─────────────────────────────────────────────────┤                                                                          
  │ Protocol   │ Custom (Ollama tool calling)              │ Open standard (MCP)                             │                                                                          
  ├────────────┼───────────────────────────────────────────┼─────────────────────────────────────────────────┤                                                                          
  │ User       │ Your app's end users                      │ AI agent clients                                │                                                                          
  └────────────┴───────────────────────────────────────────┴─────────────────────────────────────────────────┘                                                                          
  When to Use Each                                                                                                                                                                      
                                                                                                                                                                                        
  rails-generative-ui:                                                                                                                                                                  
  - You're building a standalone Rails app with AI-powered UI                                                                                                                           
  - You want full control over rendering with ViewComponents                                                                                                                            
  - Your users interact directly with your app                                                                                                                                          
  - You want native Rails patterns (Turbo Streams, etc.)                                                                                                                                
                                                                                                                                                                                        
  mcp + mcp_ui_server:                                                                                                                                                                  
  - You want Claude Desktop / ChatGPT / other agents to use your tools                                                                                                                  
  - Your "UI" appears inside the AI client's interface                                                                                                                                  
  - You're building an MCP server that agents consume                                                                                                                                   
  - Interoperability with the MCP ecosystem matters                                                                                                                                     
                                                                                                                                                                                        
  They're Complementary                                                                                                                                                                 
                                                                                                                                                                                        
  You could use both:                                                                                                                                                                   
                                                                                                                                                                                        
  ┌─────────────────────────────────────────────────────────┐                                                                                                                           
  │  Your Rails App                                         │                                                                                                                           
  │  ┌─────────────────────────────────────────────────┐   │                                                                                                                            
  │  │ rails-generative-ui                              │   │                                                                                                                           
  │  │ → Direct users interact via browser              │   │                                                                                                                           
  │  │ → ViewComponents rendered via Turbo Streams      │   │                                                                                                                           
  │  └─────────────────────────────────────────────────┘   │                                                                                                                            
  │                                                         │                                                                                                                           
  │  ┌─────────────────────────────────────────────────┐   │                                                                                                                            
  │  │ mcp + mcp_ui_server                              │   │                                                                                                                           
  │  │ → AI agents interact via MCP protocol            │   │                                                                                                                           
  │  │ → UI rendered in agent's iframe                  │   │                                                                                                                           
  │  └─────────────────────────────────────────────────┘   │                                                                                                                            
  └─────────────────────────────────────────────────────────┘                                                                                                                           
                                                                                                                          