# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'interactor'
require 'database_cleaner'

Dir['./lib/**/*.rb'].each { |f| require f }

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

require 'support/model'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing