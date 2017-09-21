# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

require File.expand_path('../dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'rspec/its'
# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue
  ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    host: "localhost",
    username: "ryanhelsing",
    password: "",
    port: 5432,
    database: "postgres"
  )
  # ActiveRecord::Base.connection.execute "CREATE DATABASE postgresql_lo_test"
  retry
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
