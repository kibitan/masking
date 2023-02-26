# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'masking/version'

Gem::Specification.new do |spec|
  spec.name          = 'masking'
  spec.version       = Masking::VERSION
  spec.authors       = ['Chikahiro Tokoro']
  spec.email         = ['uzukifirst@gmail.com']

  spec.summary       = 'Command line tool for anonymizing databese records'
  spec.description   = 'Command line tool for anonymizing database records by parsing a SQL dump file and ' \
                       'build new SQL dump file with masking sensitive/credential data.'
  spec.homepage      = 'https://github.com/kibitan/masking'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
