require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Attention
  class Application < Rails::Application
    config.github_webhooks_validate_secret = true
    config.github_webhooks_validate_organization = ENV['VALIDATE_ORGANIZATION'] || false
    config.github_webhooks_secret = ENV['GITHUB_WEBHOOK_SECRET'] || ''
    config.active_record.raise_in_transactional_callbacks = true
  end
end
