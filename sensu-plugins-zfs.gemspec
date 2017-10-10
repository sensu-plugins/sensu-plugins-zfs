# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require 'sensu-plugins-zfs/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.authors = [
    'Benjamin Nørgaard',
    'Sensu-Plugins and contributors'
  ]
  spec.date          = Date.today.to_s
  spec.description   = 'Sensu plugin for zfs'
  spec.email = [
    'b@noergaard.dk',
    '<sensu-users@googlegroups.com>'
  ]
  spec.executables   = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  spec.files         = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md]
  spec.homepage      = 'https://github.com/sensu-plugins/sensu-plugins-zfs'
  spec.license       = 'MIT'

  spec.metadata = {
    'maintianer'         => 'sensu-plugin',
    'development_status' => 'active',
    'production_status'  => 'unstable - testing recommended',
    'release_draft'      => 'false',
    'release_prerelease' => 'false'
  }

  spec.name                   = 'sensu-plugins-zfs'
  spec.platform               = Gem::Platform::RUBY
  spec.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  spec.require_paths          = ['lib']
  spec.required_ruby_version  = '>= 2.0.0'
  spec.summary                = 'Sensu plugin for zfs'
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})
  spec.version                = SensuPluginsZFS::Version::VER_STRING

  spec.add_runtime_dependency 'sensu-plugin', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'github-markup',             '~> 1.3'
  spec.add_development_dependency 'pry',                       '~> 0.10'
  spec.add_development_dependency 'rake',                      '~> 10.0'
  spec.add_development_dependency 'redcarpet',                 '~> 3.2'
  spec.add_development_dependency 'rubocop',                   '~> 0.49.0'
  spec.add_development_dependency 'rspec',                     '~> 3.1'
  spec.add_development_dependency 'yard',                      '~> 0.8'
end
