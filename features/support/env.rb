# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "rails_generative_ui"
require "capybara/cucumber"
require "webmock/cucumber"

WebMock.disable_net_connect!(allow_localhost: true)

World(RailsGenerativeUi::Helpers::ViewHelpers)

Before do
  RailsGenerativeUi.reset_configuration!
  RailsGenerativeUi.tool_registry.clear!
end
