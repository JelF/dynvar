# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynvar/version'

Gem::Specification.new do |spec|
  spec.name          = 'dynvar'
  spec.version       = DynVar::VERSION
  spec.authors       = ['Alexander Smirnov']
  spec.email         = ['begdory4@gmail.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'http://example.com'

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = []
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.32'
  spec.add_development_dependency 'yard', '~> 0.9.1'
end
