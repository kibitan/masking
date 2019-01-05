# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'masking/version'

Gem::Specification.new do |spec|
  spec.name          = 'masking'
  spec.version       = Masking::VERSION
  spec.authors       = ['kibitan']
  spec.email         = ['uzukifirst@gmail.com']

  spec.summary       = 'database masking tool'
  spec.description   = 'TBD'
  spec.homepage      = 'https://github.com/kibitan/masking'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pre-commit'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rake-notes'
  spec.add_development_dependency 'ruby-prof'

  # linter/static analyzer
  spec.add_development_dependency 'mdl'
  spec.add_development_dependency 'rubocop'

  # test
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'

  # debug
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'tapp'
end
