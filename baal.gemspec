# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baal/version'

Gem::Specification.new do |spec|
  spec.name          = 'baal'
  spec.version       = Baal::VERSION
  spec.authors       = ['Lukas Nimmo']
  spec.email         = ['Lukas.nimmo@gmail.com']

  spec.summary       = <<-HEREDOC
    Baal is a Ruby wrapper for start-stop-daemon that attempts to make your start-stop-daemon scripts easier to build
      and read while still providing the same options you are used to. Baal, through start-stop-daemon, provides a
      myriad of ways to start new system processes and check the status of and stop existing ones.
    HEREDOC
  spec.homepage      = 'https://github.com/numbluk/baal'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 3.0'
end
