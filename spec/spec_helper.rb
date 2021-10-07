# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'interactor'

Dir['./lib/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
end
