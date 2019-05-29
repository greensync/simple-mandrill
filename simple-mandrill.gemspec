Gem::Specification.new do |s|

  s.name = 'simple-mandrill'
  s.version = '0.1.0'
  s.summary = 'Simple Mandrill API wrapper'

  s.author = 'Simon Russell'
  s.email = 'info@greensync.com.au'
  s.homepage = 'http://github.com/greensync/simple-mandrill'

  s.add_dependency 'json'

  s.add_development_dependency 'autotest-standalone'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.6.0'

  s.required_ruby_version = '>= 1.9.3'

  s.files = Dir['lib/**/*.rb'] + ['LICENSE']

end
