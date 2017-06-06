source 'https://rubygems.org'

# Find a location or specific version for a gem. place_or_version can be a
# version, which is most often used. It can also be git, which is specified as
# `git://somewhere.git#branch`. You can also use a file source location, which
# is specified as `file://some/location/on/disk`.
def location_for(place_or_version, fake_version = nil)
  if place_or_version =~ %r{^(git[:@][^#]*)#(.*)}
    [fake_version, { git: Regexp.last_match(1), branch: Regexp.last_match(2), require: false }].compact
  elsif place_or_version =~ %r{^file:\/\/(.*)}
    ['>= 0', { path: File.expand_path(Regexp.last_match(1)), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

# Used for gem conditionals
ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = "#{ruby_version_segments[0]}.#{ruby_version_segments[1]}"

group :development do
  gem "puppet-module-posix-default-r#{minor_version}", require: false, platforms: 'ruby'
  gem "puppet-module-posix-dev-r#{minor_version}",     require: false, platforms: 'ruby'
  gem "puppet-module-win-default-r#{minor_version}",   require: false, platforms: %w[mswin mingw x64_mingw]
  gem "puppet-module-win-dev-r#{minor_version}",       require: false, platforms: %w[mswin mingw x64_mingw]
  gem 'fast_gettext', '1.1.0',                         require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.1.0')
  gem 'fast_gettext',                                  require: false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.1.0') # rubocop:disable Bundler/DuplicatedGem
  gem 'guard-rake'
  gem 'json_pure', '<= 2.0.1', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
  gem 'simplecov-console'
  gem 'travis'
  gem 'travis-lint'
end

group :system_tests do
  gem "puppet-module-posix-system-r#{minor_version}",                            require: false, platforms: 'ruby'
  gem "puppet-module-win-system-r#{minor_version}",                              require: false, platforms: %w[mswin mingw x64_mingw]
  gem 'beaker', *location_for(ENV['BEAKER_VERSION'] || '>= 3')
  gem 'beaker-abs', *location_for(ENV['BEAKER_ABS_VERSION'] || '~> 0.1')
  gem 'beaker-hostgenerator', *location_for(ENV['BEAKER_HOSTGENERATOR_VERSION'])
  gem 'beaker-pe', require: false
  gem 'beaker-rspec', *location_for(ENV['BEAKER_RSPEC_VERSION'])
  gem 'beaker_spec_helper'
end

gem 'puppet', *location_for(ENV['PUPPET_GEM_VERSION'])
