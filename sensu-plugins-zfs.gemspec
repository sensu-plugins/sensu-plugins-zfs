# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensu-plugins-zfs/version'

Gem::Specification.new do |spec|
  spec.name          = "sensu-plugins-zfs"
  spec.version       = SensuPluginsZFS::VERSION
  spec.authors       = ["Benjamin Nørgaard"]
  spec.email         = ["b@noergaard.dk"]

  spec.summary       = %q{Sensu plugin for zfs}
  spec.description   = %q{Sensu plugin for zfs}
  spec.homepage      = "https://github.com/blacksails/sensu-plugins-zfs"
  spec.license       = "MIT"

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  spec.executables   = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sensu-plugin", "~> 1.4"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
