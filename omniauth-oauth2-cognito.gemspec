lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-oauth2-cognito/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-oauth2-cognito'
  spec.version       = OmniauthOauth2Cognito::VERSION
  spec.authors       = ['Arcadia Solutions']
  spec.email         = ['engineering.frontend@arcadiasolutions.com']

  spec.summary       = 'A strategy for token authentication to AWS Cognito.'
  spec.description   = 'An OmniAuth Gem authentication strategy to AWS Cognito, to be used with the Devise Gem.'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jwt'
  spec.add_dependency 'omniauth-oauth2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
