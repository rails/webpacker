Gem::Specification.new do |s|
  s.name     = 'webpacker'
  s.version  = '0.1'
  s.authors  = 'David Heinemeier Hansson'
  s.email    = 'david@basecamp.com'
  s.summary  = 'Use Webpack to manage app-like JavaScript modules in Rails'
  s.homepage = 'https://github.com/rails/webpacker'
  s.license  = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activesupport', '>= 3.0.0', '< 5.1'
  s.add_dependency 'multi_json',    '~> 1.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
end
