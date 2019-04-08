# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awssume/version'

Gem::Specification.new do |spec|
  spec.name          = 'awssume'
  spec.version       = Awssume::VERSION
  spec.authors       = ['reppard']
  spec.email         = ['reppardwalker@gmail.com']

  spec.summary       = 'Assume a role, do a thing.'
  spec.description   = [
    'This is a gem for assuming an AWS IAM role and using the returned',
    'temporary credentials to do something such as run a deploy script',
    'or execute an aws cli command.'
  ].join(' ')
  spec.homepage      = 'https://github.com/Manheim/awssume'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'aws-sdk-core'
end
