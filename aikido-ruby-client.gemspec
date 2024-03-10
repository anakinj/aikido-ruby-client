# frozen_string_literal: true

require_relative 'lib/aikido/version'

Gem::Specification.new do |spec|
  spec.name = 'aikido-ruby-client'
  spec.version = Aikido::VERSION
  spec.authors = ['Joakim Antman']
  spec.email = ['antmanj@gmail.com']

  spec.summary = 'Aikido API client'
  spec.description = 'A Ruby client for the Aikido API (https://apidocs.aikido.dev/)'
  spec.homepage = 'https://github.com/anakinj/aikido-ruby-client'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/anakinj/aikido-ruby-client'
  spec.metadata['changelog_uri'] = "https://github.com/anakinj/aikido-ruby-client/blob/#{Aikido::VERSION}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'httpx'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
