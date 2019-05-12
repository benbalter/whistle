lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whistle/version'

Gem::Specification.new do |spec|
  spec.name          = 'whistle'
  spec.version       = Whistle::VERSION
  spec.authors       = ['Ben Balter']
  spec.email         = ['ben@balter.com']

  spec.summary = <<-SUMMARY
    An unofficial Ruby client for the unofficial Whistle Pet API, unofficially
  SUMMARY

  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |file|
      file.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview'
  spec.add_dependency 'addressable'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'hashie'
  spec.add_dependency 'typhoeus'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webmock'
end
