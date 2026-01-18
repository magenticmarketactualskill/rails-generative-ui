  MCP-UI Ruby Gems                                                                                                                                                                      
                                                                                                                                                                                        
  Direct MCP-UI Integration                                                                                                                                                             
                                                                                                                                                                                        
  # Gemfile                                                                                                                                                                             
  gem "mcp", git: "https://github.com/modelcontextprotocol/ruby-sdk"                                                                                                                    
  gem "mcp_ui_server"                                                                                                                                                                   
                                                                                                                                                                                        
  The mcp_ui_server gem provides helpers for returning UI resources:                                                                                                                    
                                                                                                                                                                                        
  class ProductTool < MCP::Tool                                                                                                                                                         
    description 'Returns a product UI'                                                                                                                                                  
    input_schema(type: 'object', properties: { product_id: { type: 'string' } })                                                                                                        
                                                                                                                                                                                        
    def self.call(server_context:, product_id:)                                                                                                                                         
      ui_resource = McpUiServer.create_ui_resource(                                                                                                                                     
        uri: 'ui://product-view',                                                                                                                                                       
        content: { type: :external_url, iframeUrl: "https://myshop.com/product/#{product_id}" },                                                                                        
        encoding: :text                                                                                                                                                                 
      )                                                                                                                                                                                 
      MCP::Tool::Response.new([ui_resource])                                                                                                                                            
    end                                                                                                                                                                                 
  end                                                                                                                                                                                   
                                                                                                                                                                                        
  Source: https://mcpui.dev/guide/server/ruby/walkthrough                                                                                                                               
                                                                                                                                                                                        
  ---                                                                                                                                                                                   
  Other Ruby MCP Options (Core Protocol)                                                                                                                                                
  ┌────────────────────────────────────────────────────────┬────────────────────────────────────┬────────────────────────────────────────────────┐                                      
  │                          Gem                           │              Best For              │                    Install                     │                                      
  ├────────────────────────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────────────────┤                                      
  │ https://github.com/modelcontextprotocol/ruby-sdk       │ Core MCP (Shopify-maintained)      │ gem "mcp"                                      │                                      
  ├────────────────────────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────────────────┤                                      
  │ https://github.com/yjacquin/fast-mcp                   │ Rails integration                  │ bundle add fast-mcp + rails g fast_mcp:install │                                      
  ├────────────────────────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────────────────┤                                      
  │ https://github.com/rubyonai/mcp_on_ruby                │ Rails-native (mount at /mcp)       │ rails g mcp_on_ruby:install                    │                                      
  ├────────────────────────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────────────────┤                                      
  │ https://github.com/maquina-app/rails-mcp-server        │ LLM ↔ Rails projects               │ STDIO or HTTP mode                             │                                      
  ├────────────────────────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────────────────┤                                      
  │ https://github.com/dickdavis/model-context-protocol-rb │ Rack apps, Redis-backed production │ Works with any Rack request                    │                                      
  ├────────────────────────────────────────────────────────┼────────────────────────────────────┼────────────────────────────────────────────────┤                                      
  │ https://github.com/patvice/ruby_llm-mcp                │ RubyLLM integration                │ Full MCP 2025-06-18 support                    │                                      
  └────────────────────────────────────────────────────────┴────────────────────────────────────┴────────────────────────────────────────────────┘                                      
  ---                                                                                                                                                                                   
  Quick Start for Rails                                                                                                                                                                 
                                                                                                                                                                                        
  Option 1: fast-mcp (recommended for Rails)                                                                                                                                            
  bundle add fast-mcp                                                                                                                                                                   
  bin/rails generate fast_mcp:install                                                                                                                                                   
  Creates a configurable config/initializers/fast_mcp.rb.                                                                                                                               
                                                                                                                                                                                        
  Option 2: mcp_on_ruby                                                                                                                                                                 
  rails generate mcp_on_ruby:install                                                                                                                                                    
  Server available at http://localhost:3000/mcp.                                                                                                                                        
                                                                                                                                                                                        
  ---                                                                                                                                                                                   
  Key Consideration                                                                                                                                                                     
                                                                                                                                                                                        
  The core MCP Ruby gems support the protocol, but MCP-UI specifically (the UI extension with iframes/remote-dom) requires mcp_ui_server on top of the base mcp gem. If you need the    
  full interactive UI capabilities (product selectors, checkout flows, etc.), you'll want both gems.                                                                                    
