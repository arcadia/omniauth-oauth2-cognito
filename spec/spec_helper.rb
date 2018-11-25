require 'bundler/setup'
require 'omniauth_oauth2_cognito'
require 'byebug'
require 'simplecov'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

SimpleCov.start do
  add_filter 'spec/'
  add_filter 'lib/omniauth_cognito_idp/version'
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = 'random'
end
