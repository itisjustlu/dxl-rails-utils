Gem::Specification.new do |s|
  s.name = 'dxl'
  s.version     = '4.0.2'
  s.summary     = 'Basic Rails Utils'
  s.description = 'Basic Rails Utils'
  s.author      = 'Lu Juarez'
  s.files       = `git ls-files -- {lib,spec}/*`.split("\n")
  s.homepage    = 'https://github.com/itslujuarez/dxl-rails-utils'
  s.email       = 'itisjustlu2@gmail.com'
  s.license     = 'MIT'

  s.add_dependency 'activesupport', '>= 8'
  s.add_dependency 'interactor', '~> 3.2'
  s.add_dependency 'faraday'
  s.add_development_dependency 'rspec', '~> 3.13.2'
  s.add_development_dependency 'pry', '~> 0.14.2'
  s.add_development_dependency 'sqlite3', '~> 2.7.3'
  s.add_development_dependency 'database_cleaner'

  s.test_files = Dir['spec/**/*']
end
