# frozen_string_literal: true

require_relative "lib/rails_generative_ui/version"

Gem::Specification.new do |spec|
  spec.name = "rails-generative-ui"
  spec.version = RailsGenerativeUi::VERSION
  spec.authors = ["Rails Generative UI Team"]
  spec.email = ["info@example.com"]

  spec.summary = "Generative UI integration for Ruby on Rails"
  spec.description = "Add generative UI capabilities to Rails applications using Ollama and ViewComponents. " \
                     "Create dynamic, AI-powered user interfaces that go beyond traditional chatbox interactions."
  spec.homepage = "https://github.com/example/rails-generative-ui"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/example/rails-generative-ui"
  spec.metadata["changelog_uri"] = "https://github.com/example/rails-generative-ui/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "faraday", ">= 2.0"
  spec.add_dependency "faraday-retry", ">= 2.0"
  spec.add_dependency "dry-schema", ">= 1.13"
  spec.add_dependency "turbo-rails", ">= 1.0"

  # Development dependencies
  spec.add_development_dependency "rspec-rails", ">= 6.0"
  spec.add_development_dependency "cucumber-rails", ">= 2.0"
  spec.add_development_dependency "factory_bot_rails", ">= 6.0"
  spec.add_development_dependency "webmock", ">= 3.0"
  spec.add_development_dependency "simplecov", ">= 0.22"
  spec.add_development_dependency "rubocop", ">= 1.0"
  spec.add_development_dependency "rubocop-rails", ">= 2.0"
  spec.add_development_dependency "rubocop-rspec", ">= 2.0"
  spec.add_development_dependency "capybara", ">= 3.0"
  spec.add_development_dependency "selenium-webdriver", ">= 4.0"
end
