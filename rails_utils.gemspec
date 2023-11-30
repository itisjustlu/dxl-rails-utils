# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'dxl'
  s.version     = '2.9.8'
  s.summary     = 'Basic Rails Utils for Talenthack'
  s.description = 'Basic Rails Utils for Talenthack'
  s.author      = 'hello@thetalenthack.com'
  s.files       = `git ls-files -- {lib,spec}/*`.split("\n")
  s.homepage    = 'https://github.com/itslujuarez/dxl-rails-utils'
  s.email       = 'hello@thetalenthack.com'
  s.license     = 'MIT'

  s.add_dependency 'activerecord', '>= 7'
  s.add_dependency 'activesupport', '>= 7'
  s.add_dependency 'activemodel', '>= 7'
  s.add_dependency 'store_model'
  s.add_dependency 'interactor', '~> 3.0'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'jsonapi-serializer'
  s.add_dependency 'jwt'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'pry', '~> 0.13.1'
  s.add_development_dependency 'sqlite3', '~> 1.4'
  s.add_development_dependency 'database_cleaner'

  s.test_files = Dir['spec/**/*']
end
