# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'shared_helpers/version'

Gem::Specification.new do |spec|
  spec.name = 'shared_helpers'
  spec.version = SharedHelpers::VERSION
  spec.authors = ['Evvnt Dev Team']
  spec.email = ['dev@evvnt.com']

  spec.summary = 'Shared Helpers between Marketing & Ticketing App'
  spec.homepage = 'http://github.com/evvnt/shared_helpers'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'zeitwerk', '~> 2.1'

  spec.add_development_dependency 'pry', '~>0.10'
  spec.add_development_dependency 'bundler', '>= 1.13'
  spec.add_development_dependency 'rspec', '~> 3.5'
end