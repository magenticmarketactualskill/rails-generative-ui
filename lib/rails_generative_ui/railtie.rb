# frozen_string_literal: true

module RailsGenerativeUi
  class Railtie < ::Rails::Railtie
    railtie_name :rails_generative_ui

    initializer "rails_generative_ui.view_helpers" do
      ActiveSupport.on_load(:action_controller) do
        include RailsGenerativeUi::Helpers::ControllerHelpers
      end

      ActiveSupport.on_load(:action_view) do
        include RailsGenerativeUi::Helpers::ViewHelpers
      end
    end

    initializer "rails_generative_ui.assets" do |app|
      app.config.assets.paths << root.join("app/assets/stylesheets")
      app.config.assets.paths << root.join("app/assets/javascripts")
      app.config.assets.precompile += %w[rails_generative_ui.css rails_generative_ui.js]
    end

    initializer "rails_generative_ui.tool_discovery" do
      config.after_initialize do
        tool_paths = Rails.root.join("app/generative_ui/tools/**/*.rb")
        Dir.glob(tool_paths).each { |file| require file }
      end
    end

    def root
      Pathname.new(File.expand_path("../..", __dir__))
    end
  end
end
