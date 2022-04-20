# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'rails_utils'
  s.version     = '1.14.0'
  s.summary     = 'Basic Rails Utils for Talenthack'
  s.description = 'Basic Rails Utils for Talenthack'
  s.author      = 'hello@thetalenthack.com'
  s.files       = `git ls-files -- {lib,spec}/*`.split("\n")
  s.homepage    = 'https://github.com/thetalenthack/rails-utils'
  s.email       = 'hello@thetalenthack.com'
  s.license     = 'MIT'

  s.add_dependency 'activerecord', '~> 7'
  s.add_dependency 'activesupport', '~> 7'
  s.add_dependency 'activemodel', '~> 7'
  s.add_dependency 'dry-struct', '~> 1.0'
  s.add_dependency 'interactor', '~> 3.0'
  s.add_dependency 'faraday'
  s.add_dependency 'jsonapi-serializer'
  s.add_dependency 'jwt'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'pry', '~> 0.13.1'

  s.test_files = Dir['spec/**/*']
end
